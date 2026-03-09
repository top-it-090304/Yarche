extends Node2D

@onready var continue_button: TextureButton = $CanvasLayer/Control/Continue

signal continue_game

func _ready():
	continue_button.continue_button_pressed.connect(_continue_game)
	
func _continue_game():
	continue_game.emit()
