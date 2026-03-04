extends TextureButton

signal continue_button_pressed

func _ready():
	pressed.connect(_on_continue_button_pressed)
	
func _on_continue_button_pressed():
	continue_button_pressed.emit()
