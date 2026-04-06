extends Node2D
@export var timer_time: float
@onready var timer: Timer = $GameTimer
@onready var game_world: Node = $game_world
var tutorial_scene = preload("res://scenes/levels/HitTheBeaverGame/HitTutorial.tscn")
signal win
signal lose

func _ready():
	timer.wait_time = timer_time
	game_world.score_overed.connect(_win)
	timer.timeout.connect(_lose)
	timer.start()
	show_tutorial()

func _win():
	win.emit()
	
func _lose():
	lose.emit()

func show_tutorial():
	get_tree().paused = true
	var tutorial = tutorial_scene.instantiate()
	tutorial.tutorial_finished.connect(_start_game)
	add_child(tutorial)

func _start_game():
	get_tree().paused = false
