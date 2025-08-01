extends Node

const TILE_SIZE := 8
var flag: Area2D = null
var phase2 := false

func get_player():
	return get_tree().get_first_node_in_group("Player")

func get_flag():
	return flag
