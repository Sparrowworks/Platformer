class_name Ghost extends Enemy


func _ready() -> void:
	animated_sprite_2d.play("normal")


func collision_check(body: Node2D) -> void:
	# A ghost is killable only if the player has immunity
	if body.is_in_group("Player"):
		if Globals.player.is_immune:
			player_hit.emit(false)
			kill()
		else:
			player_hit.emit(true)
	else:
		if direction == Vector2.RIGHT:
			turn_left()
		else:
			turn_right()


func move(delta: float) -> void:
	super(delta)

	global_position += direction * actual_speed * delta


func kill() -> void:
	animated_sprite_2d.play("dead")
	super()


func _on_player_tracked() -> void:
	actual_speed = chase_speed
	animated_sprite_2d.play("chase")


func _on_player_tracked_stopped() -> void:
	actual_speed = speed
	animated_sprite_2d.play("normal")
