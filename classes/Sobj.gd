@tool
extends RigidBody2D
class_name Sobj


@onready var sprite: Sprite2D = $Sprite
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

@export var auto_generate: bool:
	set(value):
		if Engine.is_editor_hint() and value:
			generate_collision_from_sprite()
		auto_generate = false  # 防止重复触发

func _ready() -> void:
	pass

func generate_collision_from_sprite():
	if sprite.texture == null:
		push_warning("Sprite2D 没有纹理，无法生成碰撞区域。")
		return

	var img: Image = sprite.texture.get_image()

	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(img, 0.1)

	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, img.get_size()), 2.0)
	if polygons.size() > 0:
		collision_polygon.polygon = polygons[0]
		if sprite.centered:
			collision_polygon.position = -img.get_size() / 2
		else:
			collision_polygon.position = Vector2.ZERO
		print("✅ 生成碰撞多边形成功")
	else:
		push_warning("未检测到不透明区域。")
