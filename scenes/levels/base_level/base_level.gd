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
		
		game.continue_game.connect(_on_game_continued)
		game.restart.connect(_on_level_restarted)
		game.back_to_menu.connect(_back_to_menu)
		add_child(game)
	else:
		_back_to_menu()
	
func _on_game_continued():
	game.queue_free()
	
	game_path_id += 1
	time_index += 1
	
	_load_current_game()
	
func _on_level_restarted():
	get_tree().tree_changed.connect(_play_again)
	get_tree().reload_current_scene()
	
func _back_to_menu():
	get_tree().tree_changed.connect(_play_again)
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
	

func _play_again():
	get_tree().paused = false
	get_tree().tree_changed.disconnect(_play_again)
func _show_end_scene():
	print("Все игры пройдены!")
	
