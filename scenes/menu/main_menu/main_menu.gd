extends CanvasLayer
const LEVEL_MENU = preload("res://scenes/menu/level_menu/level_menu.tscn")
@onready var main_menu_ui: Control = $MainMenuUi
var flag = false
func _ready():
	main_menu_ui.play_button_pressed.connect(_show_level_menu)
	
func _show_level_menu():
	var level_menu = LEVEL_MENU.instantiate()
	level_menu.position = Vector2(0, -get_viewport().get_visible_rect().size.y)
	level_menu.modulate = Color(1,1,1,0)
	add_child(level_menu)
	
	_close_main_menu()
	_show_level_menu_with_dissolve(level_menu)

func _close_main_menu():
	main_menu_ui.position = Vector2(0,0)
	var tween_close_main_menu_ui = create_tween().set_parallel(true)
	tween_close_main_menu_ui.tween_property(main_menu_ui, "modulate", Color(1,1,1,0), 0.5)
	tween_close_main_menu_ui.tween_property(main_menu_ui, "position", Vector2(0, 720), 0.5)
	tween_close_main_menu_ui.tween_callback(_delete_ui).set_delay(0.5)

func _show_level_menu_with_dissolve(level_menu):
	var tween_show_level_menu = create_tween().set_parallel(true)
	tween_show_level_menu.tween_property(level_menu, "modulate", Color(1,1,1,1), 0.5)
	tween_show_level_menu.tween_property(level_menu, "position", Vector2(0,0), 0.5)
	
func _delete_ui():
	main_menu_ui.queue_free()
