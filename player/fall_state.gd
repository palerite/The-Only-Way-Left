extends State

@export var DOWNWARDS_GRAVITY_MULTIPLIER: float = 1.6

@export var jump_state: State
@export var move_state: State
@export var dash_state: State

@export var buffer_timer: Timer
@export var coyote_timer: Timer
@export var landing_particles: GPUParticles2D

@export var animation_player: AnimationPlayer

@export var fall_sound: AudioStreamPlayer

func unhandled_input(event: InputEvent) -> void:
	super(event)
	if master.dash_available and event.is_action_pressed("dash"):
		transition(dash_state)
	if event.is_action_pressed("jump"):
		if coyote_timer.time_left:
			transition(jump_state)
			master.jump()
		else:
			buffer_timer.start()

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	var dir = master.get_dir()
	
	var acceleration = master.TOP_SPEED * Global.TILE_SIZE / (master.AIR_ACCELERATION_TIME if master.is_accelerating() else master.AIR_DECCELERATION_TIME)
	master.velocity.x = move_toward(master.velocity.x, master.TOP_SPEED * Global.TILE_SIZE * dir, delta * acceleration)
	
	master.apply_gravity(DOWNWARDS_GRAVITY_MULTIPLIER, delta)
	
	master.move_and_slide()
	if master.is_on_floor():
		transition(move_state)
	elif master.velocity.y < 0:
		transition(jump_state)

func on_enter() -> void:
	if master.velocity.y < 0:
		transition(jump_state)

func on_exit() -> void:
	if master.is_on_floor():
		master.randomize_pitch(fall_sound)
		fall_sound.play()
		animation_player.play("fall")
		landing_particles.restart()
