extends Node2D

@onready var continue_button: TextureButton = $CanvasLayer/Control/VBoxContainer/Continue
@onready var control: Control = $CanvasLayer/Control

signal continue_game

func _ready():
	continue_button.continue_button_pressed.connect(_continue_game)
	control.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1,1,1,1), 2)
	
func _continue_game():
	continue_game.emit()
