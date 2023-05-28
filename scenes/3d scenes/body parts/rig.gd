extends Node3D
class_name Rig

var root :Node3D
var shape :Node
var platformer:Platformer
@export var head_bone:Node3D

@export var connect_to_shape:=true
@export var item_holders:Array[NodePath]=[]

func _init() -> void:
	name = 'rig'
func _enter_tree() -> void:
	root = get_parent().root
	owner = root
func _ready() -> void:
	if !visible: return
	shape = root.get_node('shape')
	platformer = root.get_node('platformer')
	use_shape_size()
	platformer.connect(NL.on_state_changed, state_changed)

func use_shape_size():
	if !connect_to_shape: return
	shape.connect('on_size_changed',on_size_changed)

signal on_state_changed(state)
func state_changed(_state:StringName):
	emit_signal('on_state_changed',_state)

func on_size_changed(_size:Vector3):
	position = Vector3(0,_size.y * 0.5,0)

func get_head_bone()->Node3D:
	return head_bone

func get_item_holders()->Array:
	var holders:=[]
	for path in item_holders:
		var limb = get_node_or_null(path)
		if limb == null: 
			continue
		if !limb.has_method('get_item_holder'):
			continue
		var holder = limb.get_item_holder()
		if holder == null:
			continue
		holders.append(holder)
	return holders

#func get_item_mounts()->Array:
#	return[]
