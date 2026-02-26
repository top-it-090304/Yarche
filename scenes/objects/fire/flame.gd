extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var texture_height  = 512

func decrease_scale():
	var current_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y/2
	
	animated_sprite_2d.scale = Vector2(animated_sprite_2d.scale.x*0.8, animated_sprite_2d.scale.y*0.8)
	
	var new_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y/2
	
	animated_sprite_2d.global_position.y += (current_bottom_position - new_bottom_position)
	
