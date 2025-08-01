extends Sprite2D

func _init() -> void:
	hide()

func _ready():
	var player = Global.get_player()
	player.flag_reached.connect(fade_in)
	player.respawned.connect(reset)

func fade_in():
	$AnimationPlayer.play("fade_in")

func reset():
	hide()
