extends CharacterBody2D
var speed = 150.0
var acceleration = 15.0
var direction = Vector2.RIGHT
var MIN_SPEED = 150.0
var MAX_SPEED  = 1000.0

func set_min_speed(new_min_speed):
	MIN_SPEED = new_min_speed
func _ready():
	if has_node("../../TapGameControl"):
		var control: Control = $"../../TapGameControl"
		control.tapped.connect(_on_control_tapped)
	
func _on_control_tapped():
	if speed <MAX_SPEED:
		speed += acceleration*(1/(speed/MAX_SPEED))
func _process(delta: float) -> void:
	if speed > MIN_SPEED:
		speed -= 250*delta
	
	velocity = direction*speed
	move_and_slide()
