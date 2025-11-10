extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var animated_action: AnimatedSprite2D = $AnimatedAction

enum State {
	IDLE,
	WALK,
	JUMP,
	FALL
}

const bomb = preload("res://tscn/bomb.tscn")

const SPEED = 300.0

var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready() -> void:
	print(default_gravity)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -500
	if event.is_action_pressed("attack"):
		var instance:Bomb = bomb.instantiate()
		instance.position = self.global_position
		get_tree().current_scene.add_child(instance)

func _physics_process(_delta: float) -> void:
	pass

func transition_state(from:State,to:State) -> void:
	print("[%s][%s]from [%s]--->[%s]"%
		[
			name,
			Engine.get_physics_frames(),
			State.keys()[from] if from != -1 else "START",
			State.keys()[to]
		]
	)
	match to:
		State.IDLE:
			animated_sprite.play("idle")
			animated_action.hide()
		State.WALK:
			animated_sprite.play("run")
			animated_action.show()
			animated_action.play("run")
		State.JUMP:
			animated_sprite.play("jump")
			animated_action.show()
			animated_action.play("jump")
		State.FALL:
			animated_sprite.play("fall")
			animated_action.hide()

func get_next_state(current:State)-> State:
	var direction := Input.get_axis("left", "right")
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	match current:
		State.IDLE:
			if not is_still:
				return State.WALK
			if velocity.y < 0:
				return State.JUMP
		State.WALK:
			if is_still:
				return State.IDLE
		State.JUMP:
			if not is_on_floor():
				return State.FALL
		State.FALL:
			if is_on_floor():
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
		State.JUMP:
			if is_on_floor():
				velocity.y += 0 * delta
		State.FALL:
			velocity.x = move_toward(velocity.x,direction * SPEED,SPEED/0.2)
	if not is_zero_approx(direction):
		animated_sprite.scale.x = -1 if direction<0 else 1
	move_and_slide()
