@tool
extends Sprite3D
class_name ItemSpawner

@export var item :ItemData

func _ready() -> void:
	if item == null: 
		push_error('item spawner with null item'+ str(get_path()))
		return
	if Engine.is_editor_hint():
		setup_sprite()
	else:
		call_deferred('spawn_item')

func spawn_item():
	var child = item.prefab.instantiate()
	child.item = item
	get_parent().add_child(child)
	child.is_in_overworld = true
	child.global_transform = random_transforms()
	queue_free()

func setup_sprite():
	texture = item.icon
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	shaded = false

func random_transforms()->Transform3D:
	var child_count = get_child_count()
	if child_count <=0:
		return global_transform
	var id = randi() % child_count
	var child :Node3D= get_child(id)
	return child.global_transform
