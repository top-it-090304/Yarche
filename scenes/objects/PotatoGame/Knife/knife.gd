extends Node2D
signal sliced

var is_slicing = false
var pos_offset = Vector2(30,-370)
var rotation_start = deg_to_rad(60)
var rotation_end = deg_to_rad(-20)
@onready var swing: AudioStreamPlayer = $swing

var start_pos

func _ready() -> void:
	start_pos = global_position
	rotation = rotation_start
	scale = Vector2(0.6, 0.6)
func slice():
	if not is_slicing:
		is_slicing = true
		print("начали резать")
		slice_animation()
		swing.play()
		start_pos.x -= 70
		await get_tree().create_timer(1.2).timeout
		is_slicing = false
		print("кончили резать")
		
func slice_animation():
	var animate_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	animate_tween.tween_property(self, "position", global_position - pos_offset, 0.7)
	animate_tween.tween_property(self, "rotation",  rotation_end, 0.7)
	animate_tween.tween_property(self, "scale",  Vector2(1,1), 0.7)
	await get_tree().create_timer(0.7).timeout
	sliced.emit()
	come_back_knife()
	
func come_back_knife():
	var animate_tween = create_tween().set_parallel(true)
	animate_tween.tween_property(self, "global_position",start_pos, 0.5)
	animate_tween.tween_property(self, "rotation",  rotation_start, 0.5)
	animate_tween.tween_property(self, "scale",  Vector2(0.6,0.6), 0.5)


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		slice()
