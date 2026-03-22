extends Area2D

signal hited
signal hided
signal hide_end

@onready var life_timer: Timer = $LifeTimer
@export var x_pos: float
@export var y_pos: float

var lower_y_position 
var upper_y_position

func _ready() -> void:
	self.input_pickable = true
	self.input_event.connect(_on_input_event)
	
	self.global_position.x = x_pos
	self.global_position.y = y_pos
	
	lower_y_position = self.global_position.y + 230
	upper_y_position = self.global_position.y
	
	var start_position = Vector2(x_pos,lower_y_position )
	self.global_position = start_position
	
	var upper_position = Vector2(x_pos, upper_y_position)
	var show_tween = create_tween()
	show_tween.tween_property(self,"global_position",upper_position, 0.5)
	
	life_timer.wait_time = 1
	life_timer.one_shot = true
	life_timer.timeout.connect(func():
		hided.emit()
		_hide()
		)
	life_timer.start()
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		hited.emit()
		_hide()

func _hide():
	var end_position = Vector2(x_pos, lower_y_position)
	var hide_tween = create_tween()
	hide_tween.tween_property(self, "global_position", end_position, 0.3)
	hide_tween.tween_callback(func(): hide_end.emit())
	
