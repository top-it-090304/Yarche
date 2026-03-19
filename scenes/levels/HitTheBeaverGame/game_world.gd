extends Node

@onready var spawn_point_1: Marker2D = $SpawnPoint1Marker
@onready var spawn_point_2: Marker2D = $SpawnPoint2Marker
@onready var spawn_point_3: Marker2D = $SpawnPoint3Marker
@onready var mask1: ColorRect = $SpawnPoint1Marker/Mask


@onready var timer: Timer = $Timer

var beaver_scene = preload("res://scenes/characters/Beaver/Beaver.tscn")

signal beaver_hited

func _ready():
	_spawn_beaver(spawn_point_1.global_position)
	
func _spawn_beaver(coordinates: Vector2):
	var beaver = beaver_scene.instantiate()
	beaver.x_pos = coordinates.x
	beaver.y_pos = coordinates.y
	
	mask1.add_child(beaver)
