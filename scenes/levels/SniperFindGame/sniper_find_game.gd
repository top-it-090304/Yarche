extends Node2D

@onready var crosshair = $CanvasLayer/Crosshair
@onready var sniper = $Sniper

func _process(_delta):
	crosshair.global_position = get_global_mouse_position()
	
func _ready():
	pass
