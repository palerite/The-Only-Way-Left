extends Area2D

signal flag_reached

var triggered := false

func _ready() -> void:
	var player = Global.get_player()
	if player:
		player.respawned.connect(reset)

func reset():
	triggered = false

func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("Player"):
		player.switch_phase()
	if !triggered:
		flag_reached.emit()
		triggered = true
