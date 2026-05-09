extends Node2D

@onready var camera = $Camera2D
@onready var dark = $Dark
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
@export var timer_time = 10.0
var game_over = false

var crosshair_speed = 500.0

signal win
signal lose

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
	timer.wait_time = timer_time
	timer.start()
	crosshair.area_entered.connect(_on_sniper_found)

func spawn_sniper():
	var random_point = sniper_spawns[randi() % sniper_spawns.size()]
	sniper = sniper_scene.instantiate()
	sniper.position = random_point.position
	add_child(sniper)

func _on_sniper_found(area):
	if area.is_in_group("sniper_hitbox"):
		sniper_found()

func sniper_found():
	game_over = true
	get_tree().paused = true
	show_sniper_reveal()
	
	
func show_sniper_reveal():
	await get_tree().create_timer(1.0).timeout
	
	dark.hide()
	crosshair.hide()
	
	var zoom_tween = create_tween()
	zoom_tween.set_parallel(true)
	zoom_tween.tween_property(camera, "global_position", sniper.global_position, 1.5).set_ease(Tween.EASE_IN_OUT)
	zoom_tween.tween_property(camera, "zoom", Vector2(2.0, 2.0), 1.5).set_ease(Tween.EASE_IN_OUT)
	
	await zoom_tween.finished
	get_tree().paused = false
	win.emit()
	#sniper.play_hit_animation()
	
func _on_timer_timeout():
	game_over = true
	lose.emit()
