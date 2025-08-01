extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State
@export var dash_state: State

@export var buffer_timer: Timer
@export var coyote_timer: Timer

@export var raycast_left: RayCast2D
@export var raycast_left_verification: RayCast2D
@export var raycast_right: RayCast2D
@export var raycast_right_verification: RayCast2D

@export var BUMP_PUSH_SPEED: float = 3.0

func unhandled_input(event: InputEvent) -> void:
	if master.dash_available and event.is_action_pressed("dash"):
		transition(dash_state)

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	var dir = master.get_dir()
	
	if raycast_left.is_colliding() and !raycast_left_verification.is_colliding():
		master.position.x += BUMP_PUSH_SPEED
	elif raycast_right.is_colliding() and !raycast_right_verification.is_colliding():
		master.position.x -= BUMP_PUSH_SPEED
	
	var acceleration = master.air_acceleration if dir else master.air_decceleration
	master.velocity.x = lerpf(master.velocity.x, master.TOP_SPEED * Global.TILE_SIZE * dir, delta * acceleration)
	
	master.apply_gravity(1.0, delta)
	
	master.move_and_slide()
	if master.is_on_floor():
		transition(move_state)
	elif master.velocity.y >= 0:
		transition(fall_state)

func on_enter() -> void:
	buffer_timer.stop()
	coyote_timer.stop()

func on_exit() -> void:
	pass
