extends Node
class_name Game

#signal player_respawned

#var respawnable_children := []
#
#func _ready() -> void:
	#get_respawnable_children()
#
#func get_respawnable_children():
	#for child in get_children():
		#if child.has_method("reset"):
			#respawnable_children.push_back(child)
#
#func respawn_routine():
	#for child in respawnable_children:
		#child.on_respawn()
