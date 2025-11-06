extends CharacterBody2D
class_name Whale


@onready var animated_sprite: AnimatedSprite2D = $Graphics/AnimatedSprite
@onready var timer: Timer = $IdleTimer
@onready var ray_cast: RayCast2D = $Graphics/RayCast
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var graphics: Node2D = $Graphics
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite_dialog: Sprite2D = $Graphics/Sprite2D

enum State{
	IDLE,
	RUN,
	SWALOW,
	ATTACK,
	HIT
}
var default_gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float
var is_hit:=false

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
			var tween = create_tween()
			tween.tween_property(sprite_dialog,"visible",true,0.1)
			tween.tween_property(sprite_dialog,"scale",Vector2(0.5,0.5),0.5)
			tween.tween_property(sprite_dialog,"scale",Vector2(1,1),0.5)
			tween.tween_property(sprite_dialog,"visible",false,0.5)
			await tween.finished
		State.RUN:
			animated_sprite.play("run")
			timer.start(_random_time())
			if not floor_checker.is_colliding():
				direction *= -1
				floor_checker.force_raycast_update()
		State.SWALOW:
			animated_sprite.play("swalow")
			await animated_sprite.animation_finished
		State.ATTACK:
			animated_sprite.play("attack")
			await animated_sprite.animation_finished
		State.HIT:
			animated_sprite.play("hit")
			await animated_sprite.animation_finished
			is_hit = false

func get_next_state(current:State)->State:
	if is_hit:
		return State.HIT
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
				direction *= -1
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
			return State.IDLE
	return current

func tick_physics(current:State,delta:float)->void:
	match current:
		State.IDLE:
			_move(0,delta)
		State.RUN:
			if not floor_checker.is_colliding():
				direction *= -1 
			_move(10,delta)
		State.SWALOW:
			_move(0,delta)
		State.ATTACK:
			_move(0,delta)
		State.HIT:
			_move(0,delta)
	move_and_slide()

func _move(speed:float,delta:float)->void:
	velocity.x = move_toward(velocity.x, speed * direction, 2000*delta)
	velocity.y += default_gravity * delta
	move_and_slide()

func _random_time()->int:
	return randi() % 6

func on_explosion_hit(_pos:Vector2)->void:
	print("on_hurt")
	is_hit = true
