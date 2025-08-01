extends Sprite2D

func _init() -> void:
	hide()

func _ready():
	var flag = Global.get_flag()
	flag.flag_reached.connect(fade_in)
	Global.get_player().respawned.connect(reset)

func fade_in():
	$AnimationPlayer.play("fade_in")

func reset():
	hide()
