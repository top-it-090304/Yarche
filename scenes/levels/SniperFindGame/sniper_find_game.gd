extends Node2D

@onready var timer = $Timer
@onready var crosshair = $Crosshair
@onready var sniper_spawns = [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3,
	$SpawnPoint4,
	$SpawnPoint5
]

var sniper_scene: PackedScene = preload("res://scenes/objects/SniperFindGame/sniper.tscn")
var sniper: Node2D
var time_left: float
var game_over = false

var crosshair_speed: float = 500.0

func _process(delta):
	if game_over:
		return
	
	var target_pos = crosshair.global_position
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		target_pos = get_global_mouse_position()
	
	crosshair.global_position = crosshair.global_position.move_toward(target_pos, crosshair_speed * delta)

func _ready():
	randomize()
	spawn_sniper()
	start_timer()
	crosshair.area_entered.connect(_on_sniper_found)

func spawn_sniper():
	var random_point = sniper_spawns[randi() % sniper_spawns.size()]
	sniper = sniper_scene.instantiate()
	sniper.position = random_point.position
	add_child(sniper)

func start_timer():
	timer.start()
	time_left = timer.wait_time

func _on_sniper_found(area):
	if area.is_in_group("sniper_hitbox"):
		sniper_found()

func sniper_found():
	game_over = true
	print("Попался гад")
	
func _on_timer_timeout():
	game_over = true
	print("Не нашли")
