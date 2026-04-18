extends Area2D
@onready var dirt: Sprite2D = $Dirt
@onready var collision: CollisionPolygon2D = $Collision

signal come_back
var down_offset = 105+28
var is_clean = false

var is_dragging = false

var min_pos: Vector2
var max_pos: Vector2

var drag_offset: Vector2
func _ready():
	set_borders()
	
func clean():
	var tween = create_tween()
	tween.tween_property(dirt, "modulate", Color(1,1,1,0), 1)
	tween.set_trans(Tween.TRANS_EXPO)
	
	tween.tween_callback(func(): is_clean = true)

func finger_cover_banana(finger_position):
	return Geometry2D.is_point_in_polygon(finger_position, collision.polygon)
	
func set_borders():
	var verticies = collision.polygon
	var size = get_polygon_size(verticies)

	

	min_pos = Vector2(0,0) + size/2
	max_pos = Vector2(1500, 1080-down_offset) - size/2
	
func get_polygon_size(polygon: PackedVector2Array) -> Vector2:
	
	if polygon.is_empty():
		return Vector2.ZERO
	
	var min_x = polygon[0].x
	var max_x = polygon[0].x
	var min_y = polygon[0].y
	var max_y = polygon[0].y
	
	for v in polygon:
		min_x = min(min_x, v.x)
		max_x = max(max_x, v.x)
		min_y = min(min_y, v.y)
		max_y = max(max_y, v.y)
	
	return Vector2(max_x - min_x, max_y - min_y)
	
func _input(event):
	var finger_position = get_global_mouse_position()
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			drag_offset = finger_position - global_position
		else:
			is_dragging = false
	elif event is InputEventScreenDrag:
		var new_pos = finger_position - drag_offset
		global_position.x = clamp(new_pos.x, min_pos.x, max_pos.x)
		global_position.y = clamp(new_pos.y, min_pos.y, max_pos.y)
		 


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		clean()
		
	if area.is_in_group("plate") and is_clean:
		print("Чистый вернулся!")
		come_back.emit()
