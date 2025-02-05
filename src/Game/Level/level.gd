class_name Level extends Node2D

@onready var tiles: TileMapLayer = $Tiles
@onready var player: Player = $Player

func _ready() -> void:
	print(tiles.get_used_rect().size.x * 64 - 128)
	player.camera_limit_x = (tiles.get_used_rect().size.x * 64) - 128
