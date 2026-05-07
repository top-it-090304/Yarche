extends Sprite2D

var rotattion_offset = deg_to_rad(60)
var time = 0.0

func _process(delta: float) -> void:
	time += delta*3
	if time > PI*2:
		time = 0
	rotation = rotattion_offset*sin(time)
