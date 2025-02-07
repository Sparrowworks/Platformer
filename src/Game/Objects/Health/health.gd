class_name Health extends Node2D

signal health_collected()

@onready var animation_player: AnimationPlayer = $Area2D/AnimationPlayer
@onready var pickup_sound: AudioStreamPlayer = $Area2D/PickupSound

func _ready() -> void:
	animation_player.play("Move")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.pause()
		health_collected.emit()
		animation_player.play("Collect")

		await animation_player.animation_finished

		queue_free()
