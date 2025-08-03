extends State

@export var DASH_DISTANCE := 5.5
@export var CONTROL_DELAY_RATIO := 0.6
@export var CONTROL_STRENGTH := 200.0
@export var DASH_TIME := 0.2
@export var DECCELERATION_THRESHOLD := 0.1

@export var raycast_up: RayCast2D
@export var raycast_up_verification: RayCast2D
@export var raycast_down: RayCast2D
@export var raycast_down_verification: RayCast2D

@export var BUMP_PUSH_SPEED: float = 100.0

var decceleration_strength := (DASH_DISTANCE * Global.TILE_SIZE / DASH_TIME / 2) / DECCELERATION_THRESHOLD 
var dash_speed = (DASH_DISTANCE * Global.TILE_SIZE + (decceleration_strength * DECCELERATION_THRESHOLD**2 / 2)) / DASH_TIME
var timer := 0.0

@export var jump_state: State
@export var fall_state: State
@export var move_state: State

@export var dash_sound: AudioStreamPlayer

@onready var line = %DashLine

func unhandled_input(event: InputEvent) -> void:
	super(event)

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	timer -= delta
	
	if raycast_down.is_colliding() and !raycast_down_verification.is_colliding():
		master.position.y -= BUMP_PUSH_SPEED
	elif raycast_up.is_colliding() and !raycast_up_verification.is_colliding():
		master.position.y += BUMP_PUSH_SPEED
	
	if timer <= 0:
		transition(move_state if master.is_on_floor() else fall_state)
	elif timer <= DASH_TIME * (1.0 - CONTROL_DELAY_RATIO):
		var dir = master.get_dir()
		var target_velocity = dash_speed if dir >= 0 else 0.0
		master.velocity.x = move_toward(master.velocity.x, target_velocity, delta * CONTROL_STRENGTH)
	if timer <= DECCELERATION_THRESHOLD:
		master.velocity.x = move_toward(master.velocity.x, dash_speed / 2, delta * decceleration_strength)
	
	line.add_point(master.global_position)
	
	if master.velocity.y < 0:
		transition(jump_state)
	master.move_and_slide()

func on_enter() -> void:
	line.clear_points()
	dash_sound.play()
	master.zero_velocity()
	master.velocity.x = dash_speed
	timer = DASH_TIME
	master.lose_dash()

func on_exit() -> void:
	if Input.is_action_pressed("move_right"):
		master.velocity.x = max(master.TOP_SPEED, dash_speed/2)
	else:
		master.velocity.x = min(master.TOP_SPEED, master.velocity.x)
		
