extends Node
class_name State

@onready var master: CharacterController = get_parent().master
signal transitioning(to_state: State)

@export var stunned_state: State

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		master.respawn()

func hazard_entered():
	transition(stunned_state)

func transition(to_state: State) -> void:
	transitioning.emit(to_state)
