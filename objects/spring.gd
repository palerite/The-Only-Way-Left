extends Area2D

@export var LAUNCH_HEIGHT: float = 10.5
@export var LAUNCH_TIME: float = 0.5


func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("Player"):
		player.zero_velocity()
		player.velocity.y = -(((LAUNCH_HEIGHT * Global.TILE_SIZE) / LAUNCH_TIME) + (player.gravity * LAUNCH_TIME) / 2)
