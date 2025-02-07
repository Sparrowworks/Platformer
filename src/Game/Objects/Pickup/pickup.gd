class_name Pickup extends Node2D

signal pickup_collected(object_name: String)

@onready var animation_player: AnimationPlayer = $Area2D/AnimationPlayer
@onready var pickup_sound: AudioStreamPlayer = $Area2D/PickupSound
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	animation_player.play("Move")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collision_shape_2d.set_deferred("disabled", true)
		animation_player.pause()
		pickup_collected.emit(self.name)
		animation_player.play("Collect")
		pickup_sound.play()

		await animation_player.animation_finished

		queue_free()
