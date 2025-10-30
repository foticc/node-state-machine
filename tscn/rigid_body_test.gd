extends Node2D

@onready var button: Button = $CanvasLayer/Button
@onready var menu := PopupMenu.new()
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var context: Node2D = $Context

var left_top = Vector2(430,510)
var left = Vector2(430,555)
var right_top = Vector2(510,510)
var right = Vector2(510,555)

var test_point = Vector2.ZERO

var radius = 100
var power = 3000

func _ready() -> void:
	self.button.pressed.connect(_on_btn_pressed)
	self.canvas_layer.add_child(menu)
	menu.add_item("set point")
	menu.id_pressed.connect(_on_id_pressed)

func _draw() -> void:
	if test_point !=Vector2.ZERO:
		print("test_point",test_point)
		draw_circle(test_point,radius,Color(0, 0.8, 1, 0.3))

func _on_id_pressed(id: int)->void:
	match id:
		0:
			print("point=",get_global_mouse_position())
			self.test_point = get_global_mouse_position()
			queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		menu.popup(Rect2(event.position,Vector2.ZERO))


func _on_btn_pressed()->void:
	var children:Array[Node] = context.get_children()
	for node in children:
		if node is RigidBody2D:
			print("rigid_body:",node.global_position)
			var target = node.global_position
			var dir = target - test_point
			var dist = dir.length()
			if dist < radius:
				var falloff = 1.0 - dist / radius
				var impulse = dir.normalized() * power * falloff
				print(impulse)
				node.apply_impulse(impulse)
				#rigid_body_test.apply_impulse()
