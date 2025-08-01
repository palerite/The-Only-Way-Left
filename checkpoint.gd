extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("Player"):
		player.set_checkpoint($CheckpointMarker.global_position)
