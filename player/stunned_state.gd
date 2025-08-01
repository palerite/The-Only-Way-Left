extends State

@export var RESPAWN_DELAY := 1.4
@export var DELAY_LAG := 0.2

@export var idle_state: State

var timer := 0.0
var transition_initiated := false
var respawn_initiated := false

func unhandled_input(_event: InputEvent) -> void:
	pass

func process(delta: float) -> void:
	timer -= delta
	if timer <= (RESPAWN_DELAY - DELAY_LAG) and !transition_initiated:
		transition_initiated = true
		master.respawn_started.emit(DELAY_LAG)
	if timer <= (RESPAWN_DELAY) / 2 and !respawn_initiated:
		respawn_initiated = true
		master.respawn()
	if timer <= 0:
		transition(idle_state)

func physics_process(_delta: float) -> void:
	pass

func on_enter() -> void:
	transition_initiated = false
	respawn_initiated = false
	timer = RESPAWN_DELAY
	master.zero_velocity()

func on_exit() -> void:
	pass
	#var game = get_tree().get_first_node_in_group("Game")
	#game.respawn_routine()
