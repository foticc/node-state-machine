extends RefCounted
class_name StateMachine


var owner: Node
var current_state: State
var states := {}

func _init(_owner: Node) -> void:
	self.owner = _owner

func add_state(name: String, state: State) -> void:
	states[name] = state


func change_state(name: String) -> void:
	if not states.has(name):
		push_error("State %s not found!" % name)
		return
	if current_state:
		current_state.exit()
	current_state = states[name]
	print(current_state.get_real_class_name())
	current_state.enter(owner)

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
