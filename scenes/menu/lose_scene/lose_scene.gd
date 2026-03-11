extends Node2D

@onready var restart_button: TextureButton = $CanvasLayer/Control/Restart
@onready var back_to_main_menu_button: TextureButton = $CanvasLayer/Control/BackToMainMenu

signal restart_level
signal back_to_main_menu

func _ready():
	back_to_main_menu_button.backmenu_button_pressed.connect(_back_to_main_menu)
	restart_button.restart_button_pressed.connect(_restart)
	
func _back_to_main_menu():
	back_to_main_menu.emit()
	print("ТЫк один")
	
func _restart():
	restart_level.emit()
	print("Тык два")
