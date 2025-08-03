extends Area2D
class_name Orb

var id := 0

func _ready():
	Global.get_player().respawned.connect(reset)
	Global.get_player().flag_reached.connect(switch)

func _init() -> void:
	id = Global.get_orb_id()

func switch():
	$LightAnimationPlayer.play("switch")

func _on_body_entered(_body: Node2D) -> void:
	Global.randomize_pitch($OrbSound)
	$OrbSound.play()
	Global.orbs_pending.push_back(self)
	$AnimationPlayer.play("collected")

func reset():
	if not self in Global.orbs_collected:
		$AnimationPlayer.call_deferred("play", "RESET")
		$LightAnimationPlayer.call_deferred("play_backwards", "switch")
