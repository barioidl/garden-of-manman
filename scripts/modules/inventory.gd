extends Node
class_name Inventory

@export var slots:=Array()

@onready var root = get_parent().root

signal inventory_changed(id)
signal inventory_swapped(old_id,new_id)
func _init() -> void:
	name = 'inventory'
func _ready() -> void:
	owner = root
	root.add_to_group('inventory')
#	add_to_group('save and load')
	
	root.set_meta('get_inventory',Callable(get_inventory))
	root.set_meta('add_item',Callable(add_item))
	root.set_meta('remove_item',Callable(remove_item))
	root.set_meta('swap_item',Callable(swap_item))

func get_inventory()->Array:
	return slots

func add_item(item:ItemData,quantity:=1)->bool:
	if item == null:
		return false
	for i in slots.size():
		var slot = slots[i]
		if slot == null:
			item.quantity = clampi(item.quantity*quantity, 0, item.max_quantity)
			slots[i] = item
			emit_signal('inventory_changed',i)
	#		print('item added')
			return true
		if slot.id == item.id:
			if slot.quantity < slot.max_quantity:
				slot.quantity =clamp(slot.quantity+quantity, 0, slot.max_quantity)
#				print('item quantity added')
				return true
			else:
#				print('item quantity full')
				return false
#	print("can't add item")
	return false

func remove_item(id:int,quantity:=1):
	if id > slots.size():return
	var item :ItemData= slots[id]
	if item == null:return
	if item.quantity > quantity:
		item.quantity -= quantity
	else:
		slots[id] = null
		emit_signal('inventory_changed',id)

func swap_item(a_id,b_id):
	var tempt_item:ItemData = slots[a_id]
	slots[a_id] = slots[b_id]
	slots[b_id] = tempt_item
	emit_signal('inventory_swapped',a_id,b_id)

#func save_file():
##	ResourceLoader
##	ResourceSaver
#	pass
#func load_file():
#	pass
