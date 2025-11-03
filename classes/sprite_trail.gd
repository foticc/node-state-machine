extends Node


@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player: Player = $".."


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if (get_tree().get_frame() %6 ==0):
		var sprite:AnimatedSprite2D = animated_sprite_2d.duplicate()
		sprite.stop()
		get_tree().root.add_child(sprite)
		sprite.global_position = player.global_position
