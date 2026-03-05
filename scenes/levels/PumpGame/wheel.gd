extends AnimatedSprite2D

var target_frame_float = 0.0
var current_frame_float = 0.0
var interpolation_speed = 5.0
var frame_count = 6
var max_pressure = 4.0

func _ready():
	play("default")
	pause()

func update_frame(pressure):
	if pressure < 0.6:
		frame = 0
	elif pressure < 1.2:
		frame = 1
	elif pressure < 2.0:
		frame = 2
	elif pressure <= 2.6:
		frame = 3
	elif pressure < 3.2:
		frame = 4
	else:
		frame = 5
