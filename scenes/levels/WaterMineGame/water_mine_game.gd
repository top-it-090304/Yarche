extends Node2D
signal lose
signal win
var tutorial_scene = preload("res://scenes/levels/WaterMineGame/WaterMinesTutorial.tscn")
@export var timer_time: float = 10
@onready var timer: Timer = $Timer
@onready var gameworld: Node = $gameworld

func _ready() -> void:
	show_tutorial()
	timer.wait_time = timer_time
	timer.one_shot = true
	
	gameworld.win.connect(func(): win.emit())
	gameworld.lose.connect(func(): lose.emit())
	timer.timeout.connect(func(): lose.emit())

func show_tutorial():
	get_tree().paused = true
	var tutorial = tutorial_scene.instantiate()
	tutorial.tutorial_finished.connect(_start_game)
	add_child(tutorial)
	
func _start_game():
	get_tree().paused = false
	$AgressiveTheme.play()
	
