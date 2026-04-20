extends Node2D
signal is_clean
@onready var peel_1: Sprite2D = $Peel1
@onready var peel_2: Sprite2D = $Peel2
@onready var peel_3: Sprite2D = $Peel3

var peels

func slice():
	if peels.size() > 0:
		var peel = peels.pop_at(0)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(peel, "position:y", 1080+500, 1.0)
	else:
		is_clean.emit()
	
	
func _ready() -> void:
	peels = [peel_1, peel_2,peel_3]
