extends Node2D

@onready var game_timer = $GameTimer
var game_active = true

@export var timer_time: float
signal win
signal lose

var connected_plugs_count = 0

func _ready():
	game_timer.wait_time = timer_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	var plugs = get_tree().get_nodes_in_group("plugs")
	for plug in plugs:
		plug.plug_connected.connect(_on_plug_connected)

func _process(delta):
	pass

func _on_plug_connected():
	connected_plugs_count += 1
	if connected_plugs_count == 4:
		win.emit()
	
func _on_game_timer_timeout():
	lose.emit()
