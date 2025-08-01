extends StaticBody2D
class_name OneTimePlatform

@export var anim_player: AnimationPlayer

func _ready():
	Global.get_player().respawned.connect(reset)

func reset():
	$CrumbleTimer.stop()
	anim_player.play_backwards("crumble")
	await anim_player.animation_finished
	$CollisionShape2D.disabled = false
	$DetectionArea/CollisionShape2D.disabled = false

func crumble():
	anim_player.play("crumble")
	$CollisionShape2D.disabled = true

func _on_detection_area_body_entered(_body: Node2D) -> void:
	$DetectionArea/CollisionShape2D.set_deferred("disabled", true)
	$CrumbleTimer.start()
	anim_player.play("shake")


func _on_crumble_timer_timeout() -> void:
	crumble()
