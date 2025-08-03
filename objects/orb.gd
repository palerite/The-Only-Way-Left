extends Area2D
class_name Orb

var id := 0

func _ready():
	Global.get_player().respawned.connect(reset)

func _init() -> void:
	id = Global.get_orb_id()


func _on_body_entered(_body: Node2D) -> void:
	Global.orbs_pending.push_back(self)
	$AnimationPlayer.play("collected")

func reset():
	$AnimationPlayer.call_deferred("play", "RESET")
