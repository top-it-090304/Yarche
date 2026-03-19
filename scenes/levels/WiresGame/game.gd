extends Node2D

@onready var timer_bar = $"../TimerBar"
@onready var game_timer = $GameTimer
var game_time = 10
var game_active = true

var connected_plugs_count = 0

func _ready():
	game_timer.wait_time = game_time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timer_timeout)
	game_timer.start()
	
	timer_bar.max_value = game_time
	timer_bar.value = game_time
	
	var plugs = get_tree().get_nodes_in_group("plugs")
	print("Найдено вилок: ", plugs.size())
	for plug in plugs:
		plug.plug_connected.connect(_on_plug_connected)

func _process(delta):
	timer_bar.value = game_timer.time_left

func _on_plug_connected():
	connected_plugs_count += 1
	if connected_plugs_count == 4:
		pass
	
func _on_game_timer_timeout():
	pass
