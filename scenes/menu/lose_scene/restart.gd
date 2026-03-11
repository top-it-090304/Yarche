extends TextureButton
signal restart_button_pressed

func _ready():
	pressed.connect(_on_restart_button_pressed)
	
func _on_restart_button_pressed():
	restart_button_pressed.emit()
