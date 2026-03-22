extends Node2D
@onready var gameworld: Node = $Gameworld
@onready var tap_game_control: Control = $TapGameControl
@onready var computer_enemy: CharacterBody2D = $Gameworld/computer_enemy
@onready var timer: Timer = $Timer

@export var timer_time = 1
signal lose
signal win

func _ready():
	get_tree().paused = true
	show_tutorial()
	
func show_tutorial():
	var tutorial = preload("res://scenes/levels/TapGame/tap_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)
	

func _start_game():
	get_tree().paused = false
	_connect_game_logics()
	$Gameworld/AgressiveTheme2.play()
	
func _connect_game_logics():
	computer_enemy.hit.connect(_lose_ending)
	timer.wait_time = timer_time
	timer.one_shot = true
	
	timer.timeout.connect(_win_ending)
	timer.start()

func _win_ending():
	timer.queue_free()
	win.emit()

func _lose_ending():
	lose.emit()
