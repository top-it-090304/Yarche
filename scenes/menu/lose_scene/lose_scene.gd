extends Node2D

@onready var restart_button: TextureButton = $CanvasLayer/Control/Control/Restart
@onready var back_to_main_menu_button: TextureButton = $CanvasLayer/Control/Control/BackToMainMenu
@onready var control: Control = $CanvasLayer/Control

signal restart_level
signal back_to_main_menu

func _ready():
	back_to_main_menu_button.backmenu_button_pressed.connect(_back_to_main_menu)
	restart_button.restart_button_pressed.connect(_restart)
	
	call_deferred("_start_fade_in")
	
func _start_fade_in():
	control.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1,1,1,1), 2)
func _back_to_main_menu():
	back_to_main_menu.emit()
	print("ТЫк один")
	
func _restart():
	restart_level.emit()
	print("Тык два")
