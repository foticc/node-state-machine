extends Node2D


@onready var button: Button = $CanvasLayer/Button
@onready var barrel: Barrel = $Barrel

const bomb = preload("res://tscn/bomb.tscn")

func _ready() -> void:
	button.pressed.connect(_on_btn_pressed)

func _on_btn_pressed()->void:
	barrel.apply_impulse(Vector2(300,-300), Vector2(randf_range(-10, 10), randf_range(-10, 10)))
