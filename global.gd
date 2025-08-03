extends Node

const TILE_SIZE := 8
var flag: Area2D = null
var phase2 := false

var orbs_collected: Array[Orb] = []
var orbs_pending: Array[Orb] = []
var current_orb_id := -1

func get_player():
	return get_tree().get_first_node_in_group("Player")

func lock_in_orbs():
	orbs_collected += orbs_pending
	pass

func randomize_pitch(obj: AudioStreamPlayer) -> void:
	obj.pitch_scale = randf_range(0.85, 1.15)

func get_orb_id() -> int:
	current_orb_id += 1
	return current_orb_id

func get_flag():
	return flag
