extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D
var selected = false

signal fish_hited

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
		

func _on_area_entered(area):
	fish_hited.emit()
	
