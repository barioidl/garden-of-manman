extends Node3D
class_name Hotbar

var root:Node3D
var inventory:Inventory
var shape:CollisionShape3D

@onready var head :HotbarUser=$"../head"
@onready var rig :Rig= $"../rig"

@export var max_items:=2
var hotbar_items:=[]

var item_holders:=[]

signal hotbar_updated
func _enter_tree() -> void:
	root = get_parent().root
	owner = root
	set_interface()
func _ready():
	inventory = root.get_node_or_null('inventory')
	shape = root.get_node_or_null('shape')
	get_item_holders()
	hotbar_items.resize(max_items)
	use_shape_size()

func set_interface():
	root.set_meta(NL.append_item, Callable(append_item))
	root.set_meta(NL.append_item_node, Callable(append_item_node))
	root.set_meta(NL.get_hotbar_items, Callable(get_hotbar_items))

@export var connect_to_shape:=true
func use_shape_size():
	if !connect_to_shape: return
	if shape == null: return
	shape.connect('on_size_changed',on_size_changed)

func on_size_changed(_size:Vector3):
	position = Vector3(0,_size.y * 0.5,0)

func get_item_holders():
	item_holders = rig.get_item_holders()
	max_items = item_holders.size()

func append_item(item:ItemData)->bool:
	var id = hotbar_items.find(null) 
	if id < 0: return false
	var child = item.prefab.instantiate()
	add_child(child)
	child.item = item
	setup_item(id,child)
	return true

func append_item_node(child:Node3D)->bool:
	var id = hotbar_items.find(null)
	if id < 0: return false
	child.reparent(self)
	setup_item(id,child)
	return true

func setup_item(id,child):
	hotbar_items[id]=child
	child.equip_item(self,id)
	emit_signal('hotbar_updated')


func get_hotbar_items()->Array:
	return hotbar_items

func drop_item(id:int,target:=Vector3.ZERO,strength:=0.2):
	if id >= hotbar_items.size():return
	var drop_item:ItemOverworld=hotbar_items[id]
	if drop_item == null: return
	hotbar_items[id] = null
	
	drop_item.reparent(root.get_parent())
	drop_item.unequip_item()
	
	var speed = strength*10
	var direction = drop_item.global_position.direction_to(target)
	drop_item.linear_velocity = direction*speed
