extends Sprite2D
var up = true
var speed = 200

@onready var down_border_marker: Marker2D = $DOWN_BORDER
@onready var upper_border_marker: Marker2D = $UPPER_BORDER2

var DOWN_BORDER = 0
var UPPER_BORDER = 0

func _ready():
	DOWN_BORDER = down_border_marker.global_position.y
	UPPER_BORDER = upper_border_marker.global_position.y
func _process(delta):
	position.y += speed*delta
	
	if global_position.y <=DOWN_BORDER or global_position.y >= UPPER_BORDER:
		speed *=-1
	
