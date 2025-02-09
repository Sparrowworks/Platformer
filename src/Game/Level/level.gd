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

	for pickup: Pickup in get_tree().get_nodes_in_group("PickupInternal"):
		pickup.pickup_collected.connect(player._on_pickup_collected)

	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.player_hit.connect(player._on_player_hit)

func _on_level_end_end_reached() -> void:
	level_end.emit()
