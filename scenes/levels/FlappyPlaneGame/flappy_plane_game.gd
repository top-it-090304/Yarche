extends Node2D

@export var timer_time = 25.0
@export var final_duration = 10.0

@onready var cloud_spawner = $CloudSpawner
@onready var plane = $Plane
@onready var background = $Control/Background

signal win
signal lose

func _ready():
	get_tree().paused = true
	show_tutorial()
	var darken_timer = Timer.new()
	darken_timer.wait_time = 1.0
	darken_timer.one_shot = true
	add_child(darken_timer)
	darken_timer.timeout.connect(func(): 
		var tween = create_tween()
		tween.tween_property(background, "color", Color(0.1, 0.3, 0.5), 2.0)
	)
	darken_timer.start()
	
	var game_timer = Timer.new()
	game_timer.wait_time = timer_time
	game_timer.one_shot = true
	add_child(game_timer)
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()

func _on_game_timer_timeout():
	cloud_spawner.stop_spawning()
	
	var tween = create_tween()
	tween.tween_property(background, "color", Color(0.35, 0.6, 0.9), final_duration)
	
	var win_timer = Timer.new()
	win_timer.wait_time = final_duration
	win_timer.one_shot = true
	add_child(win_timer)
	win_timer.timeout.connect(func():
		plane.is_game_active = false
		win.emit()
	)
	win_timer.start()
	
func game_over():
	lose.emit()

func show_tutorial():
	var tutorial = preload("res://scenes/levels/FlappyPlaneGame/flappy_plane_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)

func _start_game():
	get_tree().paused = false
