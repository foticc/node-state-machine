extends RigidBody2D
class_name Barrel


func _ready() -> void:
	print("Barrel:postion",global_position)

func on_explosion_hit(_pos:Vector2)->void:
	pass
