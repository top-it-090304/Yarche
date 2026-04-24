extends Node2D

# Ссылки на ноды
@onready var timer: Timer = $Timer
@onready var crosshair: Area2D = $Crosshair  # твой прицел с Area2D
@onready var sniper_spawns: Array = [
	$SpawnPoint1,
	$SpawnPoint2,
	$SpawnPoint3,
	$SpawnPoint4,
	$SpawnPoint5
]

var sniper_scene: PackedScene = preload("res://scenes/objects/SniperFindGame/sniper.tscn")
var sniper: Node2D
var time_left: float
var game_over: bool = false

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

func _process(delta):
	if game_over:
		return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		crosshair.global_position = get_global_mouse_position()

func _on_sniper_found(area):
	if area.is_in_group("sniper_hitbox"):
		sniper_found()

func sniper_found():
	game_over = true
	timer.stop()
	
func _on_timer_timeout():
	game_over = true
