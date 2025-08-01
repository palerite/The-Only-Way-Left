extends Node
class_name Game

@export var background_ap: AnimationPlayer
@export var PHASE1_COLOR: Color
@export var PHASE2_COLOR: Color
@export var particles_right: GPUParticles2D
@export var particles_left: GPUParticles2D
@export var canvas_modulate: CanvasModulate
@export var MODULATE_COLOR: Color
@export var transition_ap: AnimationPlayer

#signal player_respawned

#var respawnable_children := []
#
func _ready() -> void:
	reset()
	var player = Global.get_player()
	if player:
		player.flag_reached.connect(_on_flag_reached)
		player.respawned.connect(reset)
		player.respawn_started.connect(restart_transition)

func restart_transition(lag: float):
	transition_ap.play("slide_in")
	await transition_ap.animation_finished
	await get_tree().create_timer(lag).timeout
	if is_inside_tree():
		transition_ap.play("slide_out")
		

func reset():
	background_ap.play_backwards("switch_phase2")
	particles_left.visible = false
	particles_right.visible = true
	canvas_modulate.color = Color.WHITE

func _on_flag_reached():
	background_ap.play("switch_phase2")
	particles_left.visible = true
	particles_right.visible = false
	canvas_modulate.color = MODULATE_COLOR

#func get_respawnable_children():
	#for child in get_children():
		#if child.has_method("reset"):
			#respawnable_children.push_back(child)
#
#func respawn_routine():
	#for child in respawnable_children:
		#child.on_respawn()
