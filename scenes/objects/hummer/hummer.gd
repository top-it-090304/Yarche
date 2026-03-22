extends Node2D
@onready var hummer_sprite: Sprite2D = $Sprite2D
@onready var hit_sound: AudioStreamPlayer2D = $hit_sound

func _ready():
	_play_animation()
	hit_sound.play()
	
func _delete_hummer():
	queue_free()

func _play_animation():
	var rotate_tween = create_tween()
	rotate_tween.tween_property(hummer_sprite, "rotation", -70*3.14/180, 0.2)
	rotate_tween.tween_callback(_delete_hummer)
