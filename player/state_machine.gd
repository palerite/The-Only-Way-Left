extends Node
class_name StateMachine

@export var master: CharacterController
@export var state: State
@export var hitbox: Area2D

func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	for child in get_children():
		if child is State:
			child.transitioning.connect(change_state)

func _process(delta: float) -> void:
	state.process(delta)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

func _on_hitbox_area_entered(_area: Area2D):
	state.hazard_entered()

func _on_hitbox_body_entered(_body):
	state.hazard_entered()

func change_state(new_state: State):
	state.on_exit()
	new_state.on_enter()
	
	state = new_state
