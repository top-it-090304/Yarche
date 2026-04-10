extends Node2D
@onready var line: Line2D = $Line2D
var speed = -10
var max_offset = 10
var time = 0
var wave_length = 630/4
var k = TAU/wave_length
var points
var points_cnt

func _ready():
	points = line.points
	points_cnt = points.size()

func _process(delta):
	update_points(delta)

func update_points(delta):
	var new_points = []
	time += delta
	
	for i in range(points_cnt):
		var point = points[i]
		if i > 0:
			var phase = point.y*k + speed*time
			var x_offset = max_offset*sin(phase)
			new_points.append(Vector2(point.x + x_offset, point.y))
		else:
			new_points.append(point)
			
	line.points = new_points
		
