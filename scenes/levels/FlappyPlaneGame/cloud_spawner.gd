extends Node

@export var cloud_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_x: float = 1200

@export var top_row: float = 100
@export var middle_row_1: float = 200
@export var middle_row_2: float = 300
@export var bottom_row: float = 400

var time_since_last_spawn: float = 0.0
var is_spawning: bool = true

func _process(delta):
	if not is_spawning:
		return
	
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0
		spawn_cloud_wave()

func spawn_cloud_wave():
	# Всегда верх и низ
	spawn_cloud_at_row(top_row)
	spawn_cloud_at_row(bottom_row)
	
	# Случайно выбираем: 0 или 1 тучу в средних рядах
	var num_middle_clouds = 1  # 0 или 1
	
	if num_middle_clouds == 1:
		# Выбираем случайный средний ряд (200 или 300)
		var random_row = middle_row_1 if randi() % 2 == 0 else middle_row_2
		spawn_cloud_at_row(random_row)
		print("Туча в среднем ряду: ", random_row)
	else:
		print("Средние ряды пустые")

func spawn_cloud_at_row(y_position: float):
	var cloud = cloud_scene.instantiate()
	cloud.position = Vector2(spawn_x, y_position)
	add_child(cloud)

func stop_spawning():
	is_spawning = false
