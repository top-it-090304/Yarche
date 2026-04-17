extends Panel
class_name PaperNote

@onready var hbox_container = $VBoxContainer/HBoxContainer
@onready var texture_rect = $TextureRect

var original_position: Vector2
var original_scale: Vector2
var tween: Tween
var is_flying = false

func _ready():
	original_position = position
	original_scale = scale
	
	for cell in hbox_container.get_children():
		cell.custom_minimum_size = Vector2(80, 80)

func show_combination(buttons: Array[GameButton]):
	for i in range(3):
		var cell = hbox_container.get_child(i)
		var button = buttons[i]
		
		cell.modulate = button.button_color
		cell.texture = button.icon if button.icon else null

func fly_away():
	if is_flying:
		return
	
	is_flying = true
	tween = create_tween()
	
	var target_y = get_viewport().get_visible_rect().size.y + 200
	tween.tween_property(self, "position:y", target_y, 0.8)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.6)
	tween.parallel().tween_property(self, "scale", original_scale * 0.9, 0.8)
	
	await tween.finished
	hide()
