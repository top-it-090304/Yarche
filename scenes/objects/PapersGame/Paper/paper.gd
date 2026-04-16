extends Area2D
@onready var label: RichTextLabel = $RichTextLabel
@onready var collision: CollisionShape2D = $collsion

var min_pos
var max_pos

var state
var is_dragging = false
var drag_offset

enum PaperState {
	RIGHT,
	WRONG
}
var data = [
	{
		"text" : "Снизить налоги",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Помогать бедным",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Повышение прожиточного минимума",
		"state": PaperState.RIGHT
	},
	{
		"text" : "Поддержать терроризм",
		"state": PaperState.WRONG
	},
	{
		"text" : "15% зарплаты в казино",
		"state": PaperState.WRONG
	},
	{
		"text" : "Власть у котиков",
		"state": PaperState.WRONG
	},
]
func _ready():
	set_window_borders()
	set_random_state()
	
func set_random_state():
	var info = data.pick_random()
	label.text = info.text
	state = info.state

func _input(event):
	var finger_position = get_global_mouse_position()
	
	if event is InputEventScreenTouch:
		if event.pressed:
			start_drag(finger_position)
		else:
			stop_drag()
	elif event is InputEventScreenDrag:
		update_drag(finger_position)

func start_drag(finger_position):
	is_dragging = true
	drag_offset = finger_position - global_position
	
	var animate_tween = create_tween().set_parallel(true)
	animate_tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.2)
	animate_tween.tween_property(self, "rotation", deg_to_rad(6), 0.2)
	
func update_drag(finger_position):
	var new_pos = finger_position - drag_offset
	global_position.x = clamp(new_pos.x, min_pos.x, max_pos.x)
	global_position.y = clamp(new_pos.y, min_pos.y, max_pos.y)
		
func stop_drag():
	is_dragging = false
	
	var animate_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	animate_tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	animate_tween.tween_property(self, "rotation", deg_to_rad(0), 0.2)
	
func set_window_borders():
	var size = collision.shape.size
	
	min_pos = get_viewport().get_visible_rect().position + size/2
	max_pos = min_pos + get_viewport().get_visible_rect().size - size
