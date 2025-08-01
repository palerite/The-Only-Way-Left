extends State

@export var jump_state: State
@export var fall_state: State
@export var move_state: State
@export var dash_state: State

func unhandled_input(event: InputEvent) -> void:
	if master.dash_available and event.is_action_pressed("dash"):
		transition(dash_state)
	if event.is_action_pressed("jump"):
		transition(jump_state)
		master.jump()

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	if !master.is_on_floor():
		transition(fall_state)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		transition(move_state)

func on_enter() -> void:
	master.zero_velocity()
	if !master.dash_available:
		master.regain_dash()

func on_exit() -> void:
	pass
