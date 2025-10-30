extends RigidBody2D
class_name Bomb

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_range: Area2D = $ExplosionRange
@onready var ball_area: Area2D = $BallArea

func _ready() -> void:
	self.explosion_range.body_entered.connect(_notify)
	print("position：",self.global_position)
	self.ball_area.body_entered.connect(_on_body_entered)
	boom()

func _physics_process(_delta: float) -> void:
	rotation = 0


func boom()->void:
	await get_tree().create_timer(1).timeout
	animated_sprite.play(&"boom")
	self.explosion_range.monitoring = true
	await animated_sprite.animation_finished
	queue_free()

func _notify(body:Node2D)->void:
	if body is Barrel:
		var dir = (body.global_position - global_position)
		print("body:",body.global_position,"self:",self.global_position)
		var distance = dir.length()
		print("distance",distance)
		if distance < 100:
			var strength = (1.0 - distance / 100) * 400
			print("strength",strength)
			body.apply_impulse(dir.normalized() * 300)
			if body.has_method("on_explosion_hit"):
				body.on_explosion_hit(global_position)
	elif body is Whale:
		if body.has_method("on_explosion_hit"):
			body.on_explosion_hit(global_position)

func _on_body_entered(body:Node2D)->void:
	if body is Whale:
		var dir = (self.position-body.position).normalized()
		print("dir--->:",dir)
		var target = dir * Vector2(10,10)
		var tween = create_tween()
		tween.tween_property(self,"position",self.position-target,0.2)
		await tween.finished
		queue_free()
