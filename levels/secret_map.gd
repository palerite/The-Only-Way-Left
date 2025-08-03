extends TileMapLayer
class_name SecretMap


func _on_trigger_body_entered(_body: Node2D) -> void:
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_OUT)
