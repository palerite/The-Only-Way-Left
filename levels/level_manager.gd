extends Node

var LEVEL_HEIGHT := 216.0 + 2 * Global.TILE_SIZE
var initial_level: PackedScene
@export var camera: Camera2D
@export var player: CharacterController

var loaded_levels: Array[Level] = []

func _ready() -> void:
	initial_level = preload("res://levels/level1.tscn")
	load_level(initial_level)
	if loaded_levels[0].next_level:
		load_level(loaded_levels[0].next_level)
	var camera_offset = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"), 
		ProjectSettings.get_setting("display/window/size/viewport_height")
	) / 2
	camera.offset = camera_offset

func load_level(level_scene: PackedScene):
	if !level_scene:
		return
	var level: Level = level_scene.instantiate()
	if loaded_levels:
		level.position = loaded_levels[0].position - Vector2(0, LEVEL_HEIGHT)
	else:
		level.position = Vector2.ZERO
	loaded_levels.push_front(level)
	level.checkpoint.level_completed.connect(_on_flag_level_completed)
	add_child(level)

func unload_oldest_level():
	var unlucky_level : Level = loaded_levels.pop_back()
	unlucky_level.queue_free()

func switch_to_next_level():
	var new_level = loaded_levels[0]
	player.set_checkpoint(new_level.checkpoint.marker.global_position)
	
	var tween = create_tween()
	tween.tween_property(camera, "position", new_level.position, 1.0).set_ease(Tween.EASE_IN_OUT)
	player.respawn()
	await tween.finished
	unload_oldest_level()
	load_level(new_level.next_level)

func _on_flag_level_completed():
	switch_to_next_level()
