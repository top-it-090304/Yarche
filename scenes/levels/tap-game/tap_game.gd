extends Node2D
@onready var gameworld: Node = $Gameworld
@onready var tap_game_control: Control = $TapGameControl
@onready var computer_enemy: CharacterBody2D = $Gameworld/computer_enemy
@onready var timer: Timer = $Timer
var win_scene = preload("res://scenes/menu/win_scene/win-scene.tscn")
var lose_scene = preload("res://scenes/menu/lose_scene/LoseScene.tscn")

@export var timer_time = 1
signal continue_game
signal restart
signal back_to_menu

func _ready():
	get_tree().paused = true
	show_tutorial()
	
func show_tutorial():
	var tutorial = preload("res://scenes/levels/tap-game/tap_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)
	
func _start_game():
	get_tree().paused = false
	_connect_game_logics()
	
func _connect_game_logics():
	computer_enemy.hit.connect(_lose_ending)
	timer.wait_time = timer_time
	timer.one_shot = true
	
	timer.timeout.connect(_win_ending)
	timer.start()

func _win_ending():
	timer.queue_free()
	get_tree().paused = true
	var win_scene_instance = win_scene.instantiate()
	win_scene_instance.continue_game.connect(_continue)
	add_child(win_scene_instance)

func _lose_ending():
	get_tree().paused = true
	var lose_scene_instance = lose_scene.instantiate()
	lose_scene_instance.restart_level.connect(_restart)
	lose_scene_instance.back_to_main_menu.connect(_back_to_menu)
	add_child(lose_scene_instance)
	
	
func _continue():
	continue_game.emit()
func _back_to_menu():
	back_to_menu.emit()
func _restart():
	restart.emit()
	
func _pause_node(node):
	node.set_process_mode(Node.PROCESS_MODE_DISABLED)
func _play_node(node):
	node.set_process_mode(Node.PROCESS_MODE_INHERIT)
