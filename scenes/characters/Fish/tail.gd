extends Sprite2D

var rotation_speed = deg_to_rad(3)
const MAX_ROTATION = deg_to_rad(60)

func _process(delta: float) -> void:
	if rotation > MAX_ROTATION or rotation < -MAX_ROTATION:
		rotation_speed *=-1
	rotate(rotation_speed)
