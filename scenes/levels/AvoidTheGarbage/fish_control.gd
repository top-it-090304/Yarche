extends Control

@onready var fish: CharacterBody2D = $Fish

var is_dragging: bool = false
var drag_offset: Vector2
var texture_offset = 20
var fish_size: Vector2

func _ready() -> void:
	print(size)
	fish_size = fish.get_node("ControlShape").shape.size

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
	var global_center = collision_shape.global_position  # исправлено!
	var half_size = collision_shape.shape.size / 2
	
	return (finger_position.x >= global_center.x - half_size.x and
			finger_position.x <= global_center.x + half_size.x and
			finger_position.y >= global_center.y - half_size.y and
			finger_position.y <= global_center.y + half_size.y)

func start_drag(finger_position):
	is_dragging = true
	drag_offset = fish.global_position - finger_position

func update_drag(finger_position):
	var new_x = finger_position.x + drag_offset.x
	
	var min_x = fish_size.x / 2 - texture_offset
	var max_x = get_viewport().get_visible_rect().size.x - fish_size.x / 2 + texture_offset
	print("Ширина экрана: ", get_viewport().size.x, ", ширина рыбы: ",fish_size.x, ", отступ тексутры: ", texture_offset )
	fish.global_position.x = clamp(new_x, min_x, max_x)

func stop_drag():
	is_dragging = false
