extends Area2D
signal hited

func _ready() -> void:
	self.input_pickable = true
	
func _on_input_event(event):
	if event is InputEventScreenTouch:
		hited.emit()
		print("Нажали")
