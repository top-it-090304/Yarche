extends Node

@export var cloud_scene: PackedScene
@export var spawn_interval = 3.0
@export var spawn_x = 1200

@export var middle_row_1 = 200
@export var middle_row_2 = 250
@export var middle_row_3 = 250
@export var middle_row_4 = 300

@export var top_row = 100
@export var bottom_row = 400

var time_since_last_spawn = 0.0
var is_spawning = true

func _process(delta):
	if not is_spawning:
		return
	
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0
		spawn_cloud_wave()

func spawn_cloud_wave():
	spawn_cloud_at_row(top_row)
	spawn_cloud_at_row(bottom_row)
	
	var middle_rows = [middle_row_1, middle_row_2, middle_row_3, middle_row_4]
	var random_row = middle_rows.pick_random()
	spawn_cloud_at_row(random_row)

func spawn_cloud_at_row(y_position: float):
	var cloud = cloud_scene.instantiate()
	cloud.position = Vector2(spawn_x, y_position)
	add_child(cloud)

func stop_spawning():
	is_spawning = false
