extends Area2D
class_name Garbage
@export var texture_path: String = "res://assets/img/AvoidTheGarbage/screwdriver.png"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _setup_nodes():
	var texture: Texture2D = load(texture_path)
	if texture:
		sprite.texture = texture
		var new_shape = RectangleShape2D.new()
		new_shape.size = texture.get_size()
		
		collision_shape.shape = new_shape

func _ready():
	_setup_nodes()

func _process(delta: float) -> void:
	rotate(deg_to_rad(60)*delta)
