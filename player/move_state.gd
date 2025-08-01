extends State

@export var ACCELERATION_TIME: float = 0.085
@export var DECCELERATION_TIME: float = 0.05

@export var buffer_timer: Timer
@export var coyote_timer: Timer

@export var jump_state: State
@export var fall_state: State
@export var idle_state: State
@export var dash_state: State

func unhandled_input(event: InputEvent) -> void:
	if master.dash_available and event.is_action_pressed("dash"):
		transition(dash_state)
	if event.is_action_pressed("jump"):
		transition(jump_state)
		master.jump()

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	var dir = master.get_dir()
	
	var acceleration = master.TOP_SPEED * Global.TILE_SIZE / (ACCELERATION_TIME if dir else DECCELERATION_TIME)
	
	master.velocity.x = move_toward(master.velocity.x, master.TOP_SPEED * Global.TILE_SIZE * dir, delta * acceleration)
	
	master.move_and_slide()
	
	if !master.is_on_floor():
		transition(fall_state)
		coyote_timer.start()
	elif master.velocity == Vector2.ZERO:
		transition(idle_state)

func on_enter() -> void:
	var debug = master.velocity.x
	if buffer_timer.time_left:
		transition(jump_state)
		master.jump()
	if !master.dash_available:
		master.regain_dash()

func on_exit() -> void:
	pass
