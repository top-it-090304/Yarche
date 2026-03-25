extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D
signal fish_hited

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered():
	fish_hited.emit()
