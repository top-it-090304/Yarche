extends Node2D

@onready var game_timer = $GameTimer
var game_active = true

@export var timer_time: float
signal win
signal lose

var connected_plugs_count = 0

func _ready():
	get_tree().paused = true
	show_tutorial()
	
	game_timer.wait_time = timer_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	var plugs = get_tree().get_nodes_in_group("plugs")
	for plug in plugs:
		plug.plug_connected.connect(_on_plug_connected)

func show_tutorial():
	var tutorial = preload("res://scenes/levels/WiresGame/wires_tutorial.tscn").instantiate()
	add_child(tutorial)
	tutorial.tutorial_finished.connect(_start_game)

func _start_game():
	get_tree().paused = false

func _process(_delta):
	pass

func _on_plug_connected():
	connected_plugs_count += 1
	if connected_plugs_count == 4:
		win.emit()
	
func _on_game_timer_timeout():
	lose.emit()
