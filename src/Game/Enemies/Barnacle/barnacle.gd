class_name Barnacle extends Enemy

@onready var show_timer: Timer = $ShowTimer
@onready var hide_timer: Timer = $HideTimer

@export_range(1.0, 5.0) var max_delay: float = 2.0

var movement_tween: Tween

func _ready() -> void:
	show_timer.start()

func kill() -> void:
	if movement_tween != null:
		movement_tween.pause()

	super()

func collision_check(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Globals.player.is_immune:
			player_hit.emit(false)
			kill()
			return

		# The barnacle can only be killed while rising from or lowering to the ground.
		if animated_sprite_2d.animation == "open":
			player_hit.emit(true)
			hide_timer.paused = true
			animated_sprite_2d.play("bite")

			await animated_sprite_2d.animation_finished

			hide_timer.paused = false
			animated_sprite_2d.play("open")

		elif animated_sprite_2d.animation == "close":
			if Globals.player.velocity.y == 0:
				player_hit.emit(true)
			else:
				if Globals.player.feet_pos.global_position.y < top_pos.global_position.y:
					player_hit.emit(false)
					kill()

func _on_show_timer_timeout() -> void:
	animated_sprite_2d.play("close")
	movement_tween = get_tree().create_tween()
	movement_tween.tween_property(self, "global_position:y",global_position.y-172, 1.5)
	movement_tween.tween_callback(
		func() -> void:
			animated_sprite_2d.play("open")
			hide_timer.start()
			movement_tween.kill()
	)

func _on_hide_timer_timeout() -> void:
	animated_sprite_2d.play("close")
	movement_tween = get_tree().create_tween()
	movement_tween.tween_property(self, "global_position:y",global_position.y+172, 1.5)
	movement_tween.tween_callback(
		func() -> void:
			show_timer.wait_time = 1.5 + randf_range(1.0, max_delay)
			show_timer.start()
			movement_tween.kill()
	)
