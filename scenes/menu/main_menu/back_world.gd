extends Node
@onready var tablet: Sprite2D = $tablet

var start_pos
var time = 0
var tabl_offset = 100
var rotation_offset = deg_to_rad(10)
var is_animating = false

func _ready() -> void:
	$computer_enemy.set_min_speed(500)
	$CharacterBody2D.set_min_speed(500)
	start_pos = tablet.global_position
	tablet.global_position.y = start_pos.y - tablet.get_rect().size.y
	show_tablet()
	
func _process(delta):
	if $CharacterBody2D.global_position.x > 3000:
		$CharacterBody2D.global_position.x = -300
	if $computer_enemy.global_position.x > 2500:
		$computer_enemy.global_position.x = -900
	if is_animating:
		animate_tablet()
		time += delta
		if time > 6.28:
				time = 0

func show_tablet():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(tablet, "global_position:y", start_pos.y, 2)
	tween.tween_callback(func(): is_animating = true)

func close_tablet(time):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(tablet, "position:y", start_pos.y - tablet.get_rect().size.y, time)
func animate_tablet():
	tablet.global_position.x =  start_pos.x + tabl_offset*sin(time)
	tablet.rotation = -rotation_offset*sin(time)
