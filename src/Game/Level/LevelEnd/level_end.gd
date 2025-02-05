class_name LevelEnd extends Area2D

signal end_reached()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var win_sound: AudioStreamPlayer = $WinSound

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	win_sound.play()
	collision_shape_2d.set_deferred("disabled", true)
	animation_player.play("End")

	await win_sound.finished

	end_reached.emit()
