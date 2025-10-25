@abstract
extends RefCounted
class_name State

@abstract func enter(node:Node)->void
@abstract func exit()->void
@abstract func update(delta: float)->void
@abstract func physics_update(delta: float)->void

func get_real_class_name() -> String:
	var script = get_script()
	if script:
		return script.resource_name if script.resource_name != "" else script.get_path().get_file().get_basename()
	return get_class()
