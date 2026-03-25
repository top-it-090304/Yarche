extends Control
@onready var fish: CharacterBody2D = $Fish

var is_dragging: bool = false
var drag_offset: Vector2

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			var finger_position = get_global_mouse_position()
			if finger_cover_fish(finger_position):
				start_drag(finger_position)
		else:
			if is_dragging:
				stop_drag()
				
	elif event is InputEventScreenDrag and is_dragging:
		update_drag(event.position)
				
func finger_cover_fish(finger_position: Vector2) -> bool:
	var collision_shape = fish.get_node("ControlShape")
	var shape = collision_shape.shape
	
	# Получаем глобальную позицию центра
	var global_center = collision_shape.global_transform * Vector2.ZERO
	var half_size = shape.size / 2
	
	return (
		finger_position.x >= global_center.x - half_size.x and
		finger_position.x <= global_center.x + half_size.x and
		finger_position.y >= global_center.y - half_size.y and
		finger_position.y <= global_center.y + half_size.y
	)
	
	
func start_drag(finger_position):
	is_dragging = true
	drag_offset = fish.global_position - finger_position
func update_drag(finger_position):
	var new_x_fish_position = finger_position.x + drag_offset.x
	
	fish.global_position.x = new_x_fish_position

func stop_drag():
	is_dragging = false
