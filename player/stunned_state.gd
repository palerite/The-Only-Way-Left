extends State

@export var RESPAWN_DELAY := 1.0

@export var idle_state: State

var timer := 0.0

func unhandled_input(_event: InputEvent) -> void:
	pass

func process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		transition(idle_state)

func physics_process(_delta: float) -> void:
	pass

func on_enter() -> void:
	timer = RESPAWN_DELAY
	master.zero_velocity()

func on_exit() -> void:
	master.respawn()
	#var game = get_tree().get_first_node_in_group("Game")
	#game.respawn_routine()
