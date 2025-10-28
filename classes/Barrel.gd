extends RigidBody2D
class_name Barrel

var is_airborne: bool = false
var velocity: Vector2 = Vector2.ZERO


var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready() -> void:
	print("Barrel:postion",global_position)

func on_explosion_hit(_pos:Vector2)->void:
	pass
