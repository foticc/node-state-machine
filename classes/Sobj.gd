extends RigidBody2D
class_name Sobj

@export var texture: Texture2D


@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if texture:
		self.sprite.texture = texture
		var rect_shape = RectangleShape2D.new()
		rect_shape.size = texture.get_size()
		self.collision_shape_2d.shape = rect_shape
