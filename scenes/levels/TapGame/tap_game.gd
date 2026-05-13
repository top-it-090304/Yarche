extends Node2D
@onready var gameworld: Node = $Gameworld
@onready var tap_game_control: Control = $Gameworld/CanvasLayer/Control
@onready var computer_enemy: CharacterBody2D = $Gameworld/computer_enemy
@onready var green_player: CharacterBody2D = $Gameworld/green_player
@onready var timer: Timer = $Timer

@export var timer_time = 4
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
	
	green_player.set_max_speed(1000)
	computer_enemy.set_max_speed(800)
	
	tap_game_control.tapped.connect(_accelerate)
	timer.wait_time = timer_time
	timer.one_shot = true
	
	timer.timeout.connect(show_win_animation)
	timer.start()
func _accelerate():
	computer_enemy.accelerate()
	green_player.accelerate()
func show_win_animation():
	green_player.stop()
	computer_enemy.stop()
	computer_enemy.hit.disconnect(_lose_ending)
	await get_tree().create_timer(1).timeout
	win.emit()

func _lose_ending():
	lose.emit()
