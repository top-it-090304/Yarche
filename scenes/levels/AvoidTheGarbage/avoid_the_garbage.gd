extends Control

@onready var fish: CharacterBody2D = $Control/Fish
@onready var timer: Timer = $Timer
@export var timer_time: float = 2
var tutorial_scene = preload("res://scenes/levels/AvoidTheGarbage/move_tutorial.tscn")
signal win
signal lose

func _ready():
	get_tree().paused = true
	show_tutorial()
	timer.wait_time = timer_time
	
	timer.timeout.connect(_win_ending)
	fish.fish_hited.connect(_lose_ending)
	
	timer.start()
	
func _start_game():
	get_tree().paused = false
	$Ghosts.play()
	
func _win_ending():
	win.emit()

func _lose_ending():
	print("бамп")
	lose.emit()
	
func show_tutorial():
	var tutorial = tutorial_scene.instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)
