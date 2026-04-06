extends Node2D

@onready var plug_connected = $PlugConnected
@onready var game_timer = $GameTimer

@export var timer_time: float
signal win
signal lose

var available_x_cord = [240, 720, 1200, 1680]
var connected_plugs_count = 0

func _ready():
	randomize()
	create_random_level()
	get_tree().paused = true
	show_tutorial()
	
	game_timer.wait_time = timer_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()

func create_random_level():
	var plugs = get_tree().get_nodes_in_group("plugs")
	var sockets = get_tree().get_nodes_in_group("sockets")
	
	available_x_cord.shuffle()
	
	var i = 0
	for socket in sockets:
		socket.position.x = available_x_cord[i]
		i += 1
	
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
	plug_connected.play()
	if connected_plugs_count == 4:
		win.emit()
	
func _on_game_timer_timeout():
	lose.emit()
