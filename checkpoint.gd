extends Area2D

signal level_completed

@onready var marker = $CheckpointMarker

func _ready():
	Global.get_player().respawned.connect(reset)
	Global.get_player().flag_reached.connect(switch)

func reset():
	$LightAnimationPlayer.call_deferred("play_backwards", "switch")

func switch():
	$LightAnimationPlayer.call_deferred("play", "switch")

func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("Player"):
		if Global.phase2:
			Global.lock_in_orbs()
			level_completed.emit()
		else:
			player.set_checkpoint($CheckpointMarker.global_position)
