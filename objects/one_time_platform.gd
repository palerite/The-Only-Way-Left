extends StaticBody2D
class_name OneTimePlatform

@export var anim_player: AnimationPlayer
var tracked_body: Node2D

func _ready():
	Global.get_player().respawned.connect(reset)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

func reset():
	$CrumbleTimer.stop()
	anim_player.play_backwards("crumble")
	await anim_player.animation_finished
	$CollisionShape2D.disabled = false
	$DetectionArea/CollisionShape2D.disabled = false
	tracked_body = null

func _physics_process(_delta: float) -> void:
	if tracked_body:
		if tracked_body.is_on_floor() and !$CollisionShape2D.disabled and $CrumbleTimer.is_stopped():
			shake()

func crumble():
	anim_player.play("crumble")
	$CollisionShape2D.disabled = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	tracked_body = body

func _on_detection_area_body_exited(_body: Node2D) -> void:
	tracked_body = null

func shake():
	$DetectionArea/CollisionShape2D.set_deferred("disabled", true)
	$CrumbleTimer.start()
	anim_player.play("shake")


func _on_crumble_timer_timeout() -> void:
	crumble()
