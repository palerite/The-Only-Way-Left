extends CharacterBody2D
class_name CharacterController

@export var JUMP_HEIGHT: float = 3.6
@export var JUMP_DISTANCE: float = 5
@export var TOP_SPEED: float = 10
@export var TERMINAL_VELOCITY: float = 10

@export var AIR_ACCELERATION_TIME: float = 0.5
@export var AIR_DECCELERATION_TIME: float = 0.3

@export var state_machine: StateMachine
@export var stunned_state: State

var air_acceleration = 1.0 / AIR_ACCELERATION_TIME
var air_decceleration = 1.0 / AIR_DECCELERATION_TIME

var jump_speed: float
var gravity: float

var dash_available := true
var checkpoint: Vector2
var jumped_manually := false
var hovering := false

@warning_ignore("unused_signal")
signal respawn_started(lag: float)
signal respawned
signal flag_reached

func _ready() -> void:
	jump_speed = -2 * JUMP_HEIGHT * Global.TILE_SIZE * TOP_SPEED * Global.TILE_SIZE / (JUMP_DISTANCE/2 * Global.TILE_SIZE)
	gravity = 2 * JUMP_HEIGHT * Global.TILE_SIZE *(TOP_SPEED * Global.TILE_SIZE)**2 / (JUMP_DISTANCE/2 * Global.TILE_SIZE)**2
	set_checkpoint(position)
	respawn()

func _physics_process(_delta: float) -> void:
	if $StateMachine/DashState.timer <= 0 and %DashLine.points:
		%DashLine.remove_point(0)
	$Directional.scale.x = (sign(velocity.x) if sign(velocity.x) else 1)

func get_dir():
	return Input.get_axis("move_left", "move_right")

func is_accelerating() -> bool:
	return sign(get_dir()) == sign(velocity.x)

func jump():
	velocity.y = jump_speed
	jumped_manually = true
	
	$JumpSound.play()

func hover(duration: float):
	hovering = true
	await get_tree().create_timer(duration).timeout
	if is_inside_tree():
		hovering = false

func respawn():
	$LightAnimationPlayer.play_backwards("switch")
	position = checkpoint
	zero_velocity()
	regain_dash()
	respawned.emit()
	Global.phase2 = false
	Global.orbs_pending.clear()

func switch_phase():
	$LightAnimationPlayer.play("switch")
	flag_reached.emit()
	Global.phase2 = true

func lose_dash():
	dash_available = false

func regain_dash():
	dash_available = true

#func set_acceleration(new_acc: Vector2):
	#acceleration = new_acc

func zero_velocity():
	velocity = Vector2.ZERO

func apply_gravity(multiplier: float, delta: float) -> void:
	if !hovering:
		velocity.y = min(velocity.y + gravity * delta * multiplier, TERMINAL_VELOCITY * Global.TILE_SIZE)
	else:
		pass

func set_checkpoint(pos: Vector2):
	checkpoint = pos
