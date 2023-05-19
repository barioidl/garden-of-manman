@tool
extends Sprite3D
class_name ItemSpawner

@export var item :ItemData

func _ready() -> void:
	if Engine.is_editor_hint():
		setup_sprite()
	else:
		call_deferred('spawn_item')

func spawn_item():
	if item == null: 
		push_error('item spawner with null item'+ str(get_path()))
		return
	var child = item.prefab.instantiate()
	child.item = item
	get_parent().add_child(child)
	child.is_in_overworld = true
	child.global_transform = global_transform
	queue_free()

func setup_sprite():
	if item == null: 
		push_error('item spawner with null item'+ str(get_path()))
		return
	texture = item.icon
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	shaded = false
