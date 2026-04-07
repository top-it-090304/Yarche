extends Node2D

@onready var strelka = $Strelka

var min_pressure = 0.0
var max_pressure = 4.0

var min_angle = -144  
var max_angle = 144

var target_pressure = 0.0
var current_pressure = 0.0
var smooth_speed = 0.9

func _ready():
	target_pressure = 0.0
	current_pressure = 0.0
	update_strelka_visual(0.0)

func _process(delta):
	if abs(current_pressure - target_pressure) > 0.01:
		current_pressure = move_toward(current_pressure, target_pressure, smooth_speed * delta)
		update_strelka_visual(current_pressure)

func update_strelka(pressure):
	target_pressure = clamp(pressure, min_pressure, max_pressure)

func encrease_manometr_value(amount: float) -> float:
	target_pressure = clamp(target_pressure + amount, min_pressure, max_pressure)
	return target_pressure

func decrease_manometr_value(amount: float) -> float:
	target_pressure = clamp(target_pressure - amount, min_pressure, max_pressure)
	return target_pressure

func get_pressure() -> float:
	return target_pressure

func update_strelka_visual(pressure):
	var t = (pressure - min_pressure) / (max_pressure - min_pressure)
	var angle = lerp(min_angle, max_angle, t)
	strelka.rotation_degrees = angle
