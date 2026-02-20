extends Node2D

@onready var strelka = $Strelka

var min_pressure = 0.0
var max_pressure = 4.0

var min_angle = -144  
var max_angle = 144

func _ready():
	update_strelka(0.0)

func update_strelka(pressure):
	pressure = clamp(pressure, min_pressure, max_pressure)
	var t = (pressure - min_pressure) / (max_pressure - min_pressure)
	var angle = lerp(min_angle, max_angle, t)
	strelka.rotation_degrees = angle
