class_name Player extends CharacterBody2D

signal update_ui(score: int, coins: int, health: int, level: int, time: int)
signal player_dead

@export var camera_limit_x: int = 3840:
	set(val):
		if camera_2d:
			camera_limit_x = val
			camera_2d.limit_right = camera_limit_x

@export var camera_limit_y: int = 2160:
	set(val):
		if camera_2d:
			camera_limit_y = val
			camera_2d.limit_bottom = camera_limit_x

@export_group("Movement")
var max_speed: float = 800.0
var initial_speed: float = 500.0
var current_speed: float = 0
var speed_increment: float = 1000
var direction: Vector2

@export_group("Jumping")
var gravity: float
var max_jump_vel: float
var min_jump_vel: float
var max_jump_height: float = 128 * 3.25
var min_jump_height: float = 128 * 1.25
var jump_duration: float = 0.5
var coyote_time: float = 0.05
var buffer_time: float = 0.05

@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var feet_pos: Marker2D = $FeetPos

@onready var ui: UI = $CanvasLayer/UI

@onready var jump_long: AudioStreamPlayer = $Sounds/Jump
@onready var land_sound: AudioStreamPlayer = $Sounds/LandSound
@onready var hurt_sound: AudioStreamPlayer = $Sounds/HurtSound
@onready var death_sound: AudioStreamPlayer = $Sounds/DeathSound
@onready var enemy_kill_sound: AudioStreamPlayer = $Sounds/EnemyKillSound

@onready var time_timer: Timer = $TimeTimer
@onready var immunity_timer: Timer = $ImmunityTimer

var acceleration: float
var deceleration: float
var jump_magnitude: float = 500.0
var jump_count: int = 0
var jumps: int = 1
var was_jump_pressed: bool = false
var is_coyote_active: bool = false

var is_left_hold: bool
var is_right_hold: bool

var is_hurt: bool = false
var is_immune: bool = false


func _ready() -> void:
	Globals.player = self
	Globals.game.game_end.connect(ui._on_game_end)

	if Globals.level == 5:
		ui.set_color_white()

	var level: Level = get_parent()
	Globals.level_time = level.level_time

	camera_2d.limit_right = camera_limit_x
	time_timer.start()

	# Calculate constants for movement
	gravity = (2 * max_jump_height) / pow(jump_duration, 2)
	max_jump_vel = -sqrt(2 * gravity * max_jump_height)
	min_jump_vel = -sqrt(2 * gravity * min_jump_height)

	jump_count = jumps

	update_ui.emit(
		Globals.level_score,
		Globals.level_coins,
		Globals.player_health,
		Globals.level,
		Globals.level_time
	)


func _hurt() -> void:
	if not is_hurt:
		is_hurt = true
		Globals.player_health -= 1
		ui.play_health_anim("Decrease")
		update_ui.emit(
			Globals.level_score,
			Globals.level_coins,
			Globals.player_health,
			Globals.level,
			Globals.level_time
		)

		if Globals.player_health <= 0:
			_kill()
			return

		# Jump when the player is hurt
		velocity.x = 0
		velocity.y = max_jump_vel

		animation_player.play("Hurt")
		hurt_sound.play()

		await animation_player.animation_finished
		is_hurt = false


func _kill() -> void:
	Globals.total_deaths += 1
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(false)
	set_physics_process(false)

	time_timer.stop()
	animated_sprite_2d.play("hurt")
	death_sound.play()
	animation_player.play("Kill")
	player_dead.emit()


func _jump() -> void:
	if jump_count > 0:
		jump_long.play()
		jump_count -= 1
		was_jump_pressed = false
		velocity.y = max_jump_vel


func _coyote_time() -> void:
	await get_tree().create_timer(coyote_time).timeout
	is_coyote_active = false


func _buffer_jump() -> void:
	await get_tree().create_timer(buffer_time).timeout
	was_jump_pressed = false


func _process(_delta: float) -> void:
	is_left_hold = Input.is_action_pressed("left")
	is_right_hold = Input.is_action_pressed("right")

	# Determine which animation should be played for the player
	if is_left_hold and !is_right_hold:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

	if abs(velocity.x) > 0.1 and is_on_floor():
		animated_sprite_2d.play("walk")
	elif abs(velocity.x) < 0.1 and is_on_floor():
		animated_sprite_2d.play("stand")

	if velocity.y < 0:
		animated_sprite_2d.play("jump")

	if velocity.y > 40:
		animated_sprite_2d.play("fall")


func _physics_process(delta: float) -> void:
	var is_jump_tapped: bool = Input.is_action_just_pressed("jump")
	var is_jump_released: bool = Input.is_action_just_released("jump")

	# Move the player based on their input and clamp their speed to the max_speed
	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT

		if current_speed < 1:
			current_speed = initial_speed

		if current_speed <= max_speed:
			current_speed += speed_increment * delta

		if current_speed > max_speed:
			current_speed = max_speed

	if Input.is_action_pressed("right"):
		direction = Vector2.RIGHT

		if current_speed < 1:
			current_speed = initial_speed

		if current_speed <= max_speed:
			current_speed += speed_increment * delta

		if current_speed > max_speed:
			current_speed = max_speed

	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		current_speed = 0

	velocity.x = current_speed * direction.x
	velocity.y += gravity * delta

	# A quick jump occurs when the player taps the space key.
	if is_jump_released and velocity.y < 0:
		velocity.y = velocity.y / 2

	if jumps == 1:
		if !is_on_floor():
			# Activate coyote time
			if coyote_time > 0:
				is_coyote_active = true
				_coyote_time()

		# Allow clutch jumps mid-air when the player walks off a platform or cliff.
		if is_jump_tapped:
			if is_coyote_active:
				is_coyote_active = false
				_jump()
			if buffer_time > 0:
				was_jump_pressed = true
				_buffer_jump()
			elif buffer_time == 0 and coyote_time == 0 and is_on_floor():
				_jump()
		# Jump if the player is on floor
		elif is_jump_tapped and is_on_floor():
			_jump()

		if is_on_floor():
			# Check if the player has landed on the ground
			if jump_count == 0 and is_equal_approx(velocity.y, 20):
				land_sound.play()

			jump_count = jumps
			if coyote_time > 0:
				is_coyote_active = true
			else:
				is_coyote_active = false

			# Jump if the player pressed space while in air
			if was_jump_pressed:
				_jump()

	# Kill the player when they go off-screen
	if position.y > 2160:
		_kill()

	move_and_slide()


func _on_time_timer_timeout() -> void:
	Globals.level_time -= 1
	update_ui.emit(
		Globals.level_score,
		Globals.level_coins,
		Globals.player_health,
		Globals.level,
		Globals.level_time
	)

	if Globals.level_time == 0:
		time_timer.stop()
		_kill()


func _on_player_hit(hurt: bool) -> void:
	if hurt:
		_hurt()
	else:
		# Jump when a player has killed an enemy
		enemy_kill_sound.play()
		Globals.level_kills += 1
		Globals.level_score += 50
		ui.play_score_anim("Increase")
		velocity.y = max_jump_vel


func _on_pickup_collected(object_name: String) -> void:
	# Identify the collected pickup and apply its effects.
	if object_name.contains("Coin"):
		Globals.level_score += 100
		Globals.level_coins += 1
		ui.play_score_anim("Increase")
		ui.play_coin_anim("Increase")
	elif object_name.contains("Health"):
		Globals.player_health += 1
		ui.play_health_anim("Increase")
	elif object_name.contains("Immunity"):
		max_speed *= 1.5
		Globals.game_theme.pitch_scale = 1.25
		is_immune = true
		animation_player.play("Immunity")
		immunity_timer.start()

	update_ui.emit(
		Globals.level_score,
		Globals.level_coins,
		Globals.player_health,
		Globals.level,
		Globals.level_time
	)


func _on_immunity_timeout() -> void:
	max_speed /= 1.5
	Globals.game_theme.pitch_scale = 1
	is_immune = false

	if Globals.player_health > 0:
		animation_player.stop()


func _on_level_end_reached() -> void:
	immunity_timer.stop()
	time_timer.stop()
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	animation_player.play("Kill")
