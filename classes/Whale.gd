extends CharacterBody2D
class_name Whale


@onready var animated_sprite: AnimatedSprite2D = $Graphics/AnimatedSprite
@onready var timer: Timer = $IdleTimer
@onready var ray_cast: RayCast2D = $Graphics/RayCast
@onready var graphics: Node2D = $Graphics
@onready var state_machine: StateMachine = $StateMachine

enum State{
	IDLE,
	RUN,
	SWALOW,
	ATTACK,
	HIT
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
			timer.start(_random_time())
		State.RUN:
			animated_sprite.play("run")
			timer.start(_random_time())
		State.SWALOW:
			animated_sprite.play("swalow")
			await animated_sprite.animation_finished
		State.ATTACK:
			animated_sprite.play("attack")
			await animated_sprite.animation_finished
		State.HIT:
			animated_sprite.play("hit")
			await animated_sprite.animation_finished

func get_next_state(current:State)->State:
	var ray = ray_cast.get_collider()
	#if ray:
		#print("ray[%s]--->[%s]"%[Engine.get_physics_frames(),ray.name])
	match current:
		State.IDLE:
			if ray:
				if ray is Bomb:
					return State.SWALOW
				if ray is Player:
					return State.ATTACK
			if timer.is_stopped():
				return State.RUN
		State.RUN:
			if ray is Bomb:
				return State.SWALOW
			if ray is TileMapLayer:
				direction = -direction
				ray_cast.force_raycast_update()
				return State.IDLE
			if ray is Player:
				return State.ATTACK
		State.SWALOW:
			if ray == null:
				return State.IDLE
		State.ATTACK:
			if ray == null:
				return State.IDLE
		State.HIT:
			pass
	return current

func tick_physics(current:State,delta:float)->void:
	if not is_on_floor():
		velocity.y += default_gravity * delta
	match current:
		State.IDLE:
			velocity.x = 0
		State.RUN:
			velocity.x += direction * 50 * delta
		State.SWALOW:
			velocity.x += 0
		State.ATTACK:
			velocity.x += 0
		State.HIT:
			velocity.x += 0
	move_and_slide()

func _random_time()->int:
	return randi() % 6

func on_explosion_hit(_pos:Vector2)->void:
	print("on_hurt")
	state_machine.current_state = State.HIT
