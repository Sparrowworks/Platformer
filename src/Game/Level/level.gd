class_name Level extends Node2D

signal update_score()
signal update_health()
signal update_immunity()

signal level_end()

@onready var tiles: TileMapLayer = $Tiles
@onready var player: Player = $Player

@export var level_time: int = 200

func _ready() -> void:
	player.camera_limit_x = (tiles.get_used_rect().size.x * 128) - 128

	for pickup: Pickup in get_tree().get_nodes_in_group("Pickup"):
		pickup.pickup_collected.connect(_on_pickup_collected)

func _on_level_end_end_reached() -> void:
	level_end.emit()

func _on_pickup_collected(object_name: String) -> void:
	if object_name.contains("Coin"):
		update_score.emit()
	elif object_name.contains("Health"):
		update_health.emit()
