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

@onready var current_music: AudioStreamPlayer = $Phase1Music
@onready var other_music: AudioStreamPlayer = $Phase2Music

#signal player_respawned

#var respawnable_children := []
#
func _ready() -> void:
	reset()
	current_music.finished.connect(_on_phase1_finished)
	other_music.finished.connect(_on_phase2_finished)
	current_music.play()
	other_music.play()
	other_music.volume_db = -80.0
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
		

func _on_phase1_finished():
	$Phase1Music.play()
func _on_phase2_finished():
	$Phase2Music.play()

func swap_music():
	var tween = create_tween()
	other_music.volume_db = -10.0
	tween.set_parallel(true)
	tween.tween_property(current_music, "volume_db", -10.0, 0.4).set_ease(Tween.EASE_IN)
	tween.tween_property(other_music, "volume_db", 0.0, 0.4).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_property(current_music, "volume_db", -80.0, 0.01)
	var tmp = current_music
	current_music = other_music
	other_music = tmp

func reset():
	if Global.phase2:
		swap_music()
	background_ap.play_backwards("switch_phase2")
	particles_left.visible = false
	particles_right.visible = true
	canvas_modulate.color = Color.WHITE

func _on_flag_reached():
	swap_music()
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
