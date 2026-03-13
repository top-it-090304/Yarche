extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var texture_height  = 512
var scaling = 0.8
var playing_flag = true
signal win

func decrease_scale():
	if playing_flag:
		if animated_sprite_2d.scale.y < 0.3:
			scaling = 0
		
		var current_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y/2
		var new_bottom_position = animated_sprite_2d.global_position.y + texture_height*animated_sprite_2d.scale.y * scaling/2
		var new_position = Vector2(animated_sprite_2d.position.x,animated_sprite_2d.position.y + (current_bottom_position - new_bottom_position) )
		var tween = create_tween().set_parallel(true)
		tween.tween_property(animated_sprite_2d, "scale", Vector2(animated_sprite_2d.scale.x*scaling, animated_sprite_2d.scale.y*scaling), 0.5)
		tween.tween_property(animated_sprite_2d, "position" , new_position, 0.5)
		if scaling ==0:
			tween.tween_callback(_win)
		animated_sprite_2d.global_position.y += (current_bottom_position - new_bottom_position)
	
func _win():
	win.emit()
	playing_flag = false
	print("Игра окончена, победа")
	
func lower_volume():
	audio_stream_player_2d.volume_db -= 5
