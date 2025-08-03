extends Area2D

@export var LAUNCH_TIME: float = 0.5
@export var LAUNCH_VECTOR: Vector2 = Vector2(0, 6.5)


func _on_body_entered(body) -> void:
	var player = body
	if player.is_in_group("Player"):
		player.zero_velocity()
		
		if LAUNCH_VECTOR.y:
			player.position.y = global_position.y - 16
			player.velocity.y = -(((LAUNCH_VECTOR.y * Global.TILE_SIZE) / LAUNCH_TIME) + (player.gravity * LAUNCH_TIME) / 2)
		
		var acceleration = player.TOP_SPEED * Global.TILE_SIZE / player.AIR_DECCELERATION_TIME
		if LAUNCH_VECTOR.x:
			player.hover(0.2)
			player.position.x = global_position.x + 8 * sign(LAUNCH_VECTOR.x)
			player.velocity.x = (((LAUNCH_VECTOR.x * Global.TILE_SIZE) / LAUNCH_TIME) + (acceleration * sign(LAUNCH_VECTOR.x) * LAUNCH_TIME) / 2)
		player.regain_dash()
