class_name Slime extends Enemy


func _ready() -> void:
	animated_sprite_2d.play("walk")


func move(delta: float) -> void:
	super(delta)

	global_position += direction * speed * delta


func kill() -> void:
	animated_sprite_2d.play("dead")
	super()
