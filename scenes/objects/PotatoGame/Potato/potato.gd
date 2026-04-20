extends Node2D
signal is_clean
@onready var peel_1: Sprite2D = $Peel1
@onready var peel_2: Sprite2D = $Peel2
@onready var peel_3: Sprite2D = $Peel3

var peels

func slice():
	if peels.size() > 0:
		var peel = peels.pop_at(0)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
		tween.tween_property(peel, "global_position:y", 1080+500, 1)
		tween.tween_property(peel, "rotation", deg_to_rad(15), 1)
		tween.tween_property(peel, "scale", peel.scale*1.1, 1)
		await get_tree().create_timer(1).timeout
		check_state()
		
func check_state():
	if peels.size() == 0:
		is_clean.emit()
	
func _ready() -> void:
	peels = [peel_1, peel_2,peel_3]
