extends Control
signal tapped
func _ready():
	size = get_viewport().size
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
			handle_tap()
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			handle_tap()
			
func handle_tap():
	await get_tree().create_timer(0.1).timeout
	
	emit_signal("tapped")
