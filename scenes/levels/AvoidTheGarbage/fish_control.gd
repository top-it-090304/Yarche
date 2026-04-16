extends Control

@onready var fish: CharacterBody2D = $Fish
@onready var control_area: CollisionShape2D = $Fish/ControlArea


var is_dragging: bool = false
var drag_offset_x
var fish_size: Vector2

var min_x
var max_x

func _ready() -> void:
	var fish_capsule_shape = fish.get_node("Area2D/CollisionShape2D2").shape as CapsuleShape2D
	fish_size = Vector2(fish_capsule_shape.radius*2, fish_capsule_shape.height)
	var camera = get_viewport().get_camera_2d()
	min_x =  camera.get_screen_center_position().x - get_viewport().get_visible_rect().size.x * camera.zoom.x / 2 + fish_size.x / 2
	max_x = min_x + get_viewport().get_visible_rect().size.x -fish_size.x

func _input(event):
	var finger_position = get_global_mouse_position()
	if event is InputEventScreenTouch:
		if event.pressed:
			
			if finger_cover_fish(finger_position):
				start_drag(finger_position)
		else:
			if is_dragging:
				is_dragging = false
	elif event is InputEventScreenDrag and is_dragging:
		update_position(finger_position)

func finger_cover_fish(finger_position):
	var global_center = control_area.global_position
	var half_size = control_area.shape.size / 2
	
	return (finger_position.x >= global_center.x - half_size.x and
			finger_position.x <= global_center.x + half_size.x and
			finger_position.y >= global_center.y - half_size.y and
			finger_position.y <= global_center.y + half_size.y)

func start_drag(finger_position):
	is_dragging = true
	drag_offset_x = finger_position.x - fish.global_position.x
	
func update_position(finger_position):
	var new_x = finger_position.x - drag_offset_x
	fish.global_position.x = clamp(new_x, min_x, max_x)
