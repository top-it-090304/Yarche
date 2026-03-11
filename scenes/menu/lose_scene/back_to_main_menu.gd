extends TextureButton

signal backmenu_button_pressed

func _ready():
	pressed.connect(_on_backmenu_button_pressed)
	
func _on_backmenu_button_pressed():
	backmenu_button_pressed.emit()
