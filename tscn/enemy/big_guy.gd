extends CharacterBody2D
class_name BigGuy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var check: Area2D = $Check

enum State {
	IDLE,
	PICK
}

func _ready() -> void:
	add_to_group()


func transition_state(from:State,to:State)->void:
	match to:
		State.IDLE:
			animated_sprite.play("idle")
		State.PICK:
			animated_sprite.play("pick")


func get_next_state(current:State)->State:
	match current:
		State.IDLE:
			pass
		State.PICK:
			pass
	return current

func tick_physics(state:State,delta:float)->void:
	pass
