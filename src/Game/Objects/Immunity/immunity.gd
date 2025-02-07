class_name Immunity extends Node2D

signal immunity_collected()

@onready var animation_player: AnimationPlayer = $Immunity/AnimationPlayer
@onready var pickup_sound: AudioStreamPlayer = $Immunity/PickupSound

func _ready() -> void:
	animation_player.play("Move")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.pause()
		immunity_collected.emit()
		animation_player.play("Collect")

		await animation_player.animation_finished

		queue_free()
