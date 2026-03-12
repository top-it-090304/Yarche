extends Area2D

@export var color_type = "red" 
@export var connected_sprite : Texture2D

@onready var plug_corpus = $PlugCorpus
@onready var line = $Wire/Line
@onready var start_position = global_position

signal plug_connected

var is_dragging = false
var is_connected = false
var mouse_offset = Vector2()

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

func _input_event(viewport, event, shape_idx):
	if is_connected:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			mouse_offset = global_position - get_global_mouse_position()
			is_dragging = true
		else:
			is_dragging = false
			_try_connect()

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + mouse_offset
		_update_line()

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
