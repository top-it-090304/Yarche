extends Node
signal score_overed

@onready var spawn_data = [
	{
		"point": $SpawnPoint1Marker,
		"mask": $SpawnPoint1Marker/Mask,
		"occupied": false
	},
	{
		"point": $SpawnPoint2Marker,
		"mask": $SpawnPoint2Marker/Mask,
		"occupied": false
	},
	{
		"point": $SpawnPoint3Marker,
		"mask": $SpawnPoint3Marker/Mask,
		"occupied": false
	}
]

@onready var timer: Timer = $Timer
var beaver_scene = preload("res://scenes/characters/Beaver/Beaver.tscn")
var hummer_scene = preload("res://scenes/objects/hummer/hummer.tscn")
var score = 0
func _ready():
	timer.wait_time = 1
	timer.timeout.connect(spawn_new_beaver)
	timer.start()

func _spawn_beaver(data: Dictionary):
	var beaver = beaver_scene.instantiate()
	beaver.x_pos = data.point.global_position.x
	beaver.y_pos = data.point.global_position.y
	beaver.hided.connect(func():
		score -= 1
	)
	beaver.hited.connect(func():
		score += 1
		score_check()
		)
	beaver.hide_end.connect(func():
		data.occupied = false
		beaver.queue_free()
		)
	beaver.hited.connect(func():
		var hummer = hummer_scene.instantiate()
		hummer.global_position = beaver.global_position
		add_child(hummer)
	)
	data.mask.add_child(beaver)
	data.occupied = true

func spawn_new_beaver():
	var free_spots = []
	for spot in spawn_data:
		if not spot.occupied:
			free_spots.append(spot)
	
	if free_spots.is_empty():
		return
	
	var selected = free_spots.pick_random()
	_spawn_beaver(selected)
func score_check():
	if score >= 5:
		score_overed.emit()
