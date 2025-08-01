extends Node

const TILE_SIZE := 8

func get_player():
	return get_tree().get_first_node_in_group("Player")

func get_flag():
	return get_tree().get_first_node_in_group("Flag")
