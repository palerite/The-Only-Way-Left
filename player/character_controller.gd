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

var jump_speed: float = -2 * JUMP_HEIGHT * Global.TILE_SIZE * TOP_SPEED * Global.TILE_SIZE / (JUMP_DISTANCE/2 * Global.TILE_SIZE)
var gravity: float = 2 * JUMP_HEIGHT * Global.TILE_SIZE *(TOP_SPEED * Global.TILE_SIZE)**2 / (JUMP_DISTANCE/2 * Global.TILE_SIZE)**2

var dash_available := true
var checkpoint: Vector2
var jumped_manually := false

@warning_ignore("unused_signal")
signal respawn_started(lag: float)
signal respawned
signal flag_reached

func _ready() -> void:
	set_checkpoint(position)
	respawn()

func _physics_process(_delta: float) -> void:
	$BumpRaycasts/Directional.scale.x = (sign(velocity.x) if sign(velocity.x) else 1)

func get_dir():
	return Input.get_axis("move_left", "move_right")

func jump():
	velocity.y = jump_speed
	jumped_manually = true

func respawn():
	$AnimationPlayer.play_backwards("switch")
	position = checkpoint
	zero_velocity()
	regain_dash()
	respawned.emit()
	Global.phase2 = false

func switch_phase():
	$AnimationPlayer.play("switch")
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
	velocity.y = min(velocity.y + gravity * delta * multiplier, TERMINAL_VELOCITY * Global.TILE_SIZE)

func set_checkpoint(pos: Vector2):
	checkpoint = pos
