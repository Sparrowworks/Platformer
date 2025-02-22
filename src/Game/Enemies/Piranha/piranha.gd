class_name Piranha extends Enemy

@onready var jump_timer: Timer = $JumpTimer

@export var jump_power: float = 3.0
@export var delay: float = 0.0

var time: float = 0.0

var is_jumping: bool = false
var is_falling: bool = false
var y_direction: float = 0.0

var init_pos: Vector2

func _ready() -> void:
	init_pos = global_position
	jump_timer.wait_time = 1.0 + delay
	jump_timer.start()

func move(delta: float) -> void:
	super(delta)

	if is_jumping:
		animated_sprite_2d.play("jump")
		time += delta
		y_direction = -abs(cos(time) * jump_power)
		if abs(y_direction) < 0.2:
			y_direction = 0.0
			is_jumping = false
			is_falling = true
	elif is_falling:
		animated_sprite_2d.play("fall")
		time += delta
		y_direction = abs(cos(time) * jump_power * 2)
		if global_position.y - init_pos.y > -1.0:
			collision_shape_2d.set_deferred("disabled", true)
			y_direction = 0.0
			is_falling = false
			global_position = init_pos
			jump_timer.start()

	global_position += Vector2(0, y_direction) * actual_speed * delta

func _on_jump_timer_timeout() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	time = 0.0
	is_jumping = true
