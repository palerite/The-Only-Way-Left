extends Area2D


var triggered := false

func _ready() -> void:
	var player = Global.get_player()
	if player:
		player.respawned.connect(reset)

func reset():
	triggered = false

func _on_area_entered(area: Area2D) -> void:
	if !triggered:
		triggered = true
		var player = area.get_parent()
		if player.is_in_group("Player"):
			player.switch_phase()
