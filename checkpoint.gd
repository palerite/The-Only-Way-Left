extends Area2D

signal level_completed

@onready var marker = $CheckpointMarker

func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("Player"):
		if Global.phase2:
			level_completed.emit()
			Global.lock_in_orbs()
		else:
			player.set_checkpoint($CheckpointMarker.global_position)
