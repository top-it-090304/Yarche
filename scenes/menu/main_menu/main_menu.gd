extends CanvasLayer
const LEVEL_MENU = preload("res://scenes/menu/level_menu/level_menu.tscn")
const animation_time = 1
@onready var overlay: ColorRect = $overlay
@onready var main_menu_ui: Control = $MainMenuUi
@onready var back_world: Node = $"../back_world"

func _ready():
	main_menu_ui.play_button_pressed.connect(start_game)
	
func start_game():
	_close_main_menu()
	back_world.close_tablet(animation_time)
	await get_tree().create_timer(animation_time+1).timeout
	get_tree().change_scene_to_file("res://scenes/levels/base_level/base_level.tscn")
	
func _close_main_menu():
	main_menu_ui.position = Vector2(0,0)
	var tween_close_main_menu_ui = create_tween().set_parallel(true)
	tween_close_main_menu_ui.tween_property(main_menu_ui, "modulate", Color(1,1,1,0), animation_time)
	tween_close_main_menu_ui.tween_property(main_menu_ui, "position", Vector2(0, 1080/1.5), animation_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_close_main_menu_ui.tween_property(overlay, "modulate", Color(1,1,1,1), animation_time)
