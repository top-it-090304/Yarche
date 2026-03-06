extends Node2D

var times = [10, 7, 5]
var game_paths = [
	"res://scenes/levels/FireGame/FireGame.tscn", 
	"res://scenes/levels/tap-game/tap_game.tscn"
]
					
var game
var game_path_id = 0
var time_index = 0

func _ready():
	_load_current_game()
	
func _load_current_game():
	if game_path_id < game_paths.size() and time_index < times.size():
		var path = game_paths[game_path_id]
		game = load(path).instantiate()
		game.timer_time = times[time_index]
		
		game.end.connect(_on_game_ended)
		add_child(game)
	else:
		_show_end_scene()
	
func _on_game_ended():
	game.queue_free()
	
	game_path_id += 1
	time_index += 1
	
	_load_current_game()
	
func _show_end_scene():
	print("Все игры пройдены!")
	
