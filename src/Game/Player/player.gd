class_name Player extends CharacterBody2D

signal update_ui(score: int, coins: int, health: int, level: int, time: int)
signal player_dead()

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
@export var max_speed: float = 500.0
@export var max_time: float = 0.2
@export var zero_time: float = 0.2

@export_group("Jumping")
@export var jumps: int = 1
@export var jump_height: float = 3.5
@export var gravity: float = 20.0
@export var fall_velocity: float = 700.0
@export var fall_factor: float = 2.0
@export var coyote_time: float = 0.2
@export var buffer_time: float = 0.2

@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var feet_pos: Marker2D = $FeetPos

@onready var jump_long: AudioStreamPlayer = $Sounds/Jump
@onready var land_sound: AudioStreamPlayer = $Sounds/LandSound
@onready var hurt_sound: AudioStreamPlayer = $Sounds/HurtSound
@onready var death_sound: AudioStreamPlayer = $Sounds/DeathSound
@onready var time_timer: Timer = $TimeTimer

var applied_gravity: float
var applied_fall_gravity: float

var acceleration: float
var deceleration: float
var jump_magnitude: float = 500.0
var jump_count: int = 0
var was_jump_pressed: bool = false
var is_coyote_active: bool = false

var is_left_hold: bool
var is_right_hold: bool

var is_hurt: bool = false
var health: int = 3

var score: int = 0
var coins: int = 0
var time: int = 0

func _ready() -> void:
	Globals.player = self

	var level: Level = get_parent()
	time = level.level_time

	camera_2d.limit_right = camera_limit_x
	time_timer.start()

	jump_count = jumps

	update_ui.emit(score, coins, health, Globals.level, time)

func _hurt() -> void:
	if not is_hurt:
		is_hurt = true
		health -= 1
		update_ui.emit(score, coins, health, Globals.level, time)

		if health == 0:
			_kill()
			return

		velocity.x = 0
		velocity.y = -((jump_height * 10.0) * gravity)

		animation_player.play("Hurt")
		hurt_sound.play()

		await animation_player.animation_finished
		is_hurt = false

func _kill() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(false)
	set_physics_process(false)

	time_timer.stop()
	animated_sprite_2d.play("hurt")

	death_sound.play()
	animation_player.play("Kill")
	player_dead.emit()

func _decelerate(delta: float) -> void:
	if (abs(velocity.x) > 0) and (abs(velocity.x) <= abs((-max_speed / zero_time) * delta)):
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x += (-max_speed / zero_time) * delta
	elif velocity.x < 0:
		velocity.x -= (-max_speed / zero_time) * delta

func _jump() -> void:
	if jump_count > 0:
		jump_long.play()
		velocity.y = -((jump_height * 10.0) * gravity)
		jump_count -= 1
		was_jump_pressed = false

func _coyote_time() -> void:
	await get_tree().create_timer(coyote_time).timeout
	is_coyote_active = false

func _buffer_jump() -> void:
	await get_tree().create_timer(buffer_time).timeout
	was_jump_pressed = false

func _process(_delta: float) -> void:
	is_left_hold = Input.is_action_pressed("left")
	is_right_hold = Input.is_action_pressed("right")

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

	if is_right_hold and is_left_hold:
		_decelerate(delta)
	elif is_right_hold:
		if velocity.x > max_speed:
			velocity.x = max_speed
		else:
			velocity.x += (max_speed / max_time) * delta
		if velocity.x < 0:
			_decelerate(delta)
	elif is_left_hold:
		if velocity.x < -max_speed:
			velocity.x = -max_speed
		else:
			velocity.x -= (max_speed / max_time) * delta
		if velocity.x > 0:
			_decelerate(delta)

	if !(is_left_hold or is_right_hold):
		_decelerate(delta)

	if velocity.y > 0:
		applied_gravity = gravity * fall_factor
	else:
		applied_gravity = gravity

	applied_fall_gravity = fall_velocity

	if velocity.y < applied_fall_gravity:
		velocity.y += applied_gravity
	elif velocity.y > applied_fall_gravity:
		velocity.y = applied_fall_gravity

	if is_jump_released and velocity.y < 0:
		velocity.y = velocity.y / 2

	if jumps == 1:
		if !is_on_floor() and !is_on_wall():
			if coyote_time > 0:
				is_coyote_active = true
				_coyote_time()

		if is_jump_tapped and !is_on_wall():
			if is_coyote_active:
				is_coyote_active = false

				_jump()
			if buffer_time > 0:
				was_jump_pressed = true
				_buffer_jump()
			elif buffer_time == 0 and coyote_time == 0 and is_on_floor():
				_jump()
		elif is_jump_tapped and is_on_floor():
			_jump()

		if is_on_floor():
			if jump_count == 0 and is_equal_approx(velocity.y, 20):
				land_sound.play()

			jump_count = jumps
			if coyote_time > 0:
				is_coyote_active = true
			else:
				is_coyote_active = false
			if was_jump_pressed:
				_jump()

	if position.y > 2160:
		_kill()

	move_and_slide()


func _on_time_timer_timeout() -> void:
	time -= 1
	update_ui.emit(score, coins, health, Globals.level, time)

func _on_player_hit(is_hurt: bool) -> void:
	if is_hurt:
		_hurt()
	else:
		velocity.y = -((jump_height * 10.0) * gravity)

func _on_pickup_collected(object_name: String) -> void:
	if object_name.contains("Coin"):
		score += 100
		coins += 1
	elif object_name.contains("Health"):
		health += 1

	update_ui.emit(score, coins, health, Globals.level, time)
