extends Node2D
@onready var knife: Node2D = $Knife
@onready var potato: Node2D = $Potato


var start_swipe_pos
var end_swipe_pos
var is_swiping = false
func _ready():
	knife.sliced.connect(func(): potato.slice())
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_swiping = true
			start_swipe_pos = event.position
		else:
			if is_swiping:
				is_swiping = false
				analyze_swipe()
	elif event is InputEventScreenDrag and is_swiping:
		end_swipe_pos = event.position

func analyze_swipe():
	if start_swipe_pos !=null and end_swipe_pos!= null:
		var swipe = end_swipe_pos-start_swipe_pos
		#исключил горизонтальный свайп
		if (abs(swipe.x) > abs(swipe.y)):
			return
		elif swipe.y >0:
			print("горизонтальный свайп")
			knife.slice()
