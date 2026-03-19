extends Node

@onready var spawn_point_1: Marker2D = $SpawnPoint1Marker
@onready var spawn_point_2: Marker2D = $SpawnPoint2Marker
@onready var spawn_point_3: Marker2D = $SpawnPoint3Marker
@onready var mask1: ColorRect = $SpawnPoint1Marker/Mask
@onready var mask2: ColorRect = $SpawnPoint2Marker/Mask
@onready var mask3: ColorRect = $SpawnPoint3Marker/Mask



@onready var timer: Timer = $Timer

var beaver_scene = preload("res://scenes/characters/Beaver/Beaver.tscn")

signal beaver_hited

var beavers_coordinates = []
var coordinates = []
func _ready():
	timer.wait_time = 1
	timer.timeout.connect(spawn_new_beaver)
	timer.start()
	coordinates = [spawn_point_1.global_position,
					spawn_point_2.global_position,
					spawn_point_3.global_position
					]
	
func _spawn_beaver(coordinates: Vector2, mask_index):
	var beaver = beaver_scene.instantiate()
	beaver.x_pos = coordinates.x
	beaver.y_pos = coordinates.y
	
	match mask_index:
		0:
			mask1.add_child(beaver)
		1:
			mask2.add_child(beaver)
		2:
			mask3.add_child(beaver)
	

func spawn_new_beaver():
	print("таймер сработал, спавним")
	if beavers_coordinates.size() > 3:
		return
	else:
		var random_point_coordinates = coordinates.pick_random()
		var mask_index = coordinates.find(random_point_coordinates)
		
		if not (random_point_coordinates in beavers_coordinates):
			_spawn_beaver(random_point_coordinates, mask_index)
			beavers_coordinates.append(random_point_coordinates)
		else:
			return
