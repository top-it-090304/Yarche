extends Area2D

@export var color_type = "red" 
@export var connected_sprite : Texture2D

@onready var plug_corpus = $PlugCorpus
@onready var line = $Wire/Line
@onready var touch_area = $TouchArea
@onready var start_position = global_position

signal plug_connected

var is_dragging = false
var is_connected = false
var drag_offset = Vector2()
var touch_index = -1

func _ready():
	match color_type:
		"red":
			line.default_color = Color.RED
			plug_corpus.modulate = Color.RED
		"blue":
			line.default_color = Color.BLUE
			plug_corpus.modulate = Color.BLUE
		"green":
			line.default_color = Color.GREEN
			plug_corpus.modulate = Color.GREEN
		"yellow":
			line.default_color = Color.YELLOW
			plug_corpus.modulate = Color.YELLOW
	
	line.width = 10
	_update_line()

func _input(event):
	if is_connected:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_plug(event.position):
				touch_index = event.index
				drag_offset = global_position - event.position
				is_dragging = true
				print("Начало перетаскивания")
		else:
			if event.index == touch_index:
				is_dragging = false
				touch_index = -1
				_try_connect()
	
	if event is InputEventScreenDrag:
		if event.index == touch_index and is_dragging:
			global_position = event.position + drag_offset
			_update_line()

func _is_point_inside_plug(point):
	var local_point = to_local(point)
	var circle_shape = touch_area.shape as CircleShape2D
	var distance = local_point.length()
	return distance <= circle_shape.radius

func _try_connect():
	var overlapping_areas = get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("sockets"):
			var socket = area
			if socket.color_type == color_type:
				global_position = socket.global_position
				is_connected = true
				plug_corpus.texture = connected_sprite
				_update_line()
				plug_connected.emit()
				return
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", start_position, 0.2)
	tween.tween_callback(_update_line)

func _update_line():
	var screen_size = get_viewport().get_visible_rect().size
	var bottom = to_local(Vector2(global_position.x, screen_size.y))
	line.points = [Vector2(0, 0), bottom]
