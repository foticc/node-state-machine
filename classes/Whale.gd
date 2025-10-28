extends CharacterBody2D
class_name Whale


@onready var animated_sprite: AnimatedSprite2D = $Graphics/AnimatedSprite
@onready var timer: Timer = $IdleTimer
@onready var ray_cast: RayCast2D = $Graphics/RayCast
@onready var graphics: Node2D = $Graphics

enum State{
	IDLE,
	RUN
}
var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float

var direction := -1:
	set(v):
		direction = v
		graphics.scale.x = -direction


func _ready() -> void:
	print("on_ready")

func _physics_process(_delta: float) -> void:
	pass

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
			timer.start(_random_time())
		State.RUN:
			animated_sprite.play("run")
			timer.start(_random_time())


func get_next_state(current:State)->State:
	match current:
		State.IDLE:
			if timer.is_stopped():
				return State.RUN
		State.RUN:
			if timer.is_stopped():
				return State.IDLE
			if ray_cast.is_colliding():
				direction = -direction
				return State.IDLE
	return current

func tick_physics(current:State,delta:float)->void:
	if not is_on_floor():
		velocity.y += default_gravity * delta
	match current:
		State.IDLE:
			velocity.x = direction * delta
		State.RUN:
			velocity.x += direction * 50 * delta
	move_and_slide()

func _random_time()->int:
	return randi() % 6
