extends Area2D

@export var color_type = "red" 
@export var connected_sprite : Texture2D

@onready var plug_corpus = $PlugCorpus
@onready var line = $Wire/Line
@onready var touch_area = $TouchArea
@onready var vilks = $Vilks

@onready var start_position = global_position
var wire_start_position = Vector2()

signal plug_connected

var is_dragging = false
var is_connected = false
var drag_offset = Vector2()
var touch_index = -1

func _ready():
	match color_type:
		"red":
			line.default_color = Color(0.9, 0.2, 0.15)
			plug_corpus.modulate = Color(0.9, 0.2, 0.15)
		"blue":
			line.default_color = Color(0.0, 0.4, 1)
			plug_corpus.modulate = Color(0.0, 0.4, 1)
		"green":
			line.default_color = Color.GREEN
			plug_corpus.modulate = Color.GREEN
		"yellow":
			line.default_color = Color.YELLOW
			plug_corpus.modulate = Color.YELLOW
	
	line.width = 15

	await get_tree().process_frame
	
	var screen_size = get_viewport().get_visible_rect().size
	wire_start_position = Vector2(global_position.x, screen_size.y)
	
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
				if not is_connected:
					_return_to_start()
	
	if event is InputEventScreenDrag:
		if event.index == touch_index and is_dragging:
			global_position = event.position + drag_offset
			_update_line()
			_try_connect_while_dragging()

func _is_point_inside_plug(point):
	var local_point = to_local(point)
	var circle_shape = touch_area.shape as CircleShape2D
	var distance = local_point.length()
	return distance <= circle_shape.radius

func _try_connect_while_dragging():
	var overlapping_areas = get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("sockets"):
			var socket = area
			if socket.color_type == color_type:
				_connect_to_socket(socket)
				return

func _connect_to_socket(socket):
	global_position = socket.global_position
	is_connected = true
	plug_corpus.texture = connected_sprite
	vilks.visible = false
	_update_line()
	
	is_dragging = false
	touch_index = -1
	
	plug_connected.emit()

func _return_to_start():
	var tween = create_tween()
	tween.tween_property(self, "global_position", start_position, 0.2)
	tween.tween_callback(_update_line)

func _update_line():
	var start_point = to_local(wire_start_position)
	var end_point = Vector2.ZERO
	if is_connected: end_point = Vector2(0, -50)
	
	line.clear_points()
	
	var steps = 15
	for i in range(steps + 1):
		var t = i / float(steps)
		var point = start_point.lerp(end_point, t)
		var sag = (t - t*t) * 4 * 80 
		point.y += sag
		
		line.add_point(point)
