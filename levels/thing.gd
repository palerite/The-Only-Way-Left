extends Area2D

@export var flag: Area2D


func _on_body_entered(body: Node2D) -> void:
	flag.position.x = 2000
