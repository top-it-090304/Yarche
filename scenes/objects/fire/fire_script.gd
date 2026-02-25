extends AnimatedSprite2D
var texture_height = 512

func decrease_scale():
	var current_bottom_position = global_position.y + texture_height*scale.y/2
	
	scale = Vector2(scale.x*0.95, scale.y*0.95)
	
	var new_bottom_position = global_position.y + texture_height*scale.y/2
	
	global_position.y += (current_bottom_position - new_bottom_position)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		decrease_scale()
		
func _process(delta):
	play("burning")
