class_name Level extends Node2D

signal level_end()

@onready var tiles: TileMapLayer = $Tiles
@onready var player: Player = $Player

@export var level_time: int = 200

func _ready() -> void:
	player.camera_limit_x = (tiles.get_used_rect().size.x * 128) - 128


func _on_level_end_end_reached() -> void:
	level_end.emit()
