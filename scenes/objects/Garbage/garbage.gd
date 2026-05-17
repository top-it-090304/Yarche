extends Area2D

const presets = ["fork", "package", "screwdriver"]
func _setup_nodes():
	var preset = presets.pick_random()
	for child in get_children():
		if child.is_in_group(preset):
			if child is CollisionPolygon2D or child is CollisionShape2D:
				child.disabled = false
				child.visible = true
			else:
				child.visible = true


func _ready():
	_setup_nodes()

func _process(delta: float) -> void:
	rotate(deg_to_rad(60)*delta)
