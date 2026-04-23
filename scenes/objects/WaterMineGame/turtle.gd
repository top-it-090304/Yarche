extends RigidBody2D

@onready var anim_player = $AnimationPlayer

func _ready():
	var animation = anim_player.get_animation("walk")
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Проигрываем
	anim_player.play("walk")
