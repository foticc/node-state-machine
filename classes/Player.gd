extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var state_machine: StateMachine

var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready() -> void:
	self.state_machine = StateMachine.new(self)
	self.state_machine.add_state("walk",IdleState.new())
	self.state_machine.change_state("walk")
	print(default_gravity)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("right"):
		state_machine.change_state("walk")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	self.state_machine.update(delta)


func play_anim(anim:String)->void:
	self.animated_sprite.play(anim)
