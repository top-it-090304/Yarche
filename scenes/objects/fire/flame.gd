extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var texture_height  = 512
var scaling = 0.8
func decrease_scale():
	var current_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y/2
	
	var new_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y * scaling/2
	var new_position = Vector2(animated_sprite_2d.position.x,animated_sprite_2d.position.y + (current_bottom_position - new_bottom_position) )
	var tween = create_tween().set_parallel(true)
	tween.tween_property(animated_sprite_2d, "scale", Vector2(animated_sprite_2d.scale.x*scaling, animated_sprite_2d.scale.y*scaling), 0.5)
	tween.tween_property(animated_sprite_2d, "position" , new_position, 0.5)
	animated_sprite_2d.global_position.y += (current_bottom_position - new_bottom_position)
	
