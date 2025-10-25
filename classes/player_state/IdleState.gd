extends State
class_name IdleState


func enter(node:Node)->void:
	if node.has_method("play_anim"):
		node.play_anim("run")

func exit()->void:
	pass

func update(delta: float)->void:
	pass

func physics_update(delta: float)->void:
	pass
