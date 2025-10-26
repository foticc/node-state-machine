extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State {
	IDLE,
	WALK
}

const SPEED = 300.0

var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready() -> void:
	print(default_gravity)

func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func transition_state(from:State,to:State) -> void:
	print("[%s]from [%s]--->[%s]"%
		[
			Engine.get_physics_frames(),
			State.keys()[from] if from != -1 else "START",
			State.keys()[to]
		]
	)
	match to:
		State.IDLE:
			animated_sprite.play("idle")
		State.WALK:
			animated_sprite.play("run")

func get_next_state(current:State)-> State:
	var direction := Input.get_axis("left", "right")
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	match current:
		State.IDLE:
			if not is_still:
				return State.WALK
		State.WALK:
			if is_still:
				return State.IDLE
	return current

func tick_physics(state:State,delta:float)->void:
	var direction := Input.get_axis("left", "right")

	if not is_on_floor():
		velocity.y += default_gravity * delta
	match state:
		State.IDLE:
			pass
		State.WALK:
			if direction:
				velocity.x = move_toward(velocity.x,direction * SPEED,SPEED/0.2) 
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	if not is_zero_approx(direction):
		animated_sprite.scale.x = -1 if direction<0 else 1
	move_and_slide()
