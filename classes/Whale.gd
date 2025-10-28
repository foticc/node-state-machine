extends CharacterBody2D
class_name Whale


@onready var animated_sprite: AnimatedSprite2D = $Graphics/AnimatedSprite
@onready var timer: Timer = $IdleTimer
@onready var ray_cast: RayCast2D = $Graphics/RayCast
@onready var graphics: Node = $Graphics

enum State{
	IDLE,
	RUN
}
var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready() -> void:
	print("on_ready")

func _physics_process(_delta: float) -> void:
	if ray_cast.is_colliding():
		graphics.flip_h = true

func transition_state(from:State,to:State)->void:
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
			timer.start(3)
		State.RUN:
			animated_sprite.play("run")
			timer.start(1)


func get_next_state(current:State)->State:
	match current:
		State.IDLE:
			if timer.is_stopped():
				return State.RUN
		State.RUN:
			if timer.is_stopped():
				return State.IDLE
	return current

func tick_physics(current:State,delta:float)->void:
	if not is_on_floor():
		velocity.y += default_gravity * delta
	match current:
		State.IDLE:
			pass
		State.RUN:
			velocity.x += _get_direction() * 200 *delta
	move_and_slide()

func _get_direction()->int:
	if ray_cast.is_colliding():
		return 1
	return -1
