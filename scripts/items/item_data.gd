@tool
extends Resource
class_name ItemData

enum item_id{
	default,
	flash_light,
	
	eyejar_brown,
	eyejar_blue,
	eyejar_red,
	eyejar_green,
	
	generic_key,
	red_key,
	green_key,
	blue_key,
	yellow_key,
	purple_key,
}

@export var id:=item_id.default:
	get:
		return id
	set(value):
		id = value
		if name == '':
			name = item_id.keys()[value]
@export var name:=''
@export var quantity:=1:
	get:
		return quantity
	set(value):
		quantity = clamp(value,0,max_quantity)
@export var max_quantity:=1:
	get:
		return max_quantity
	set(value):
		if max_quantity == value: return
		max_quantity = value
		quantity = clamp(quantity,0,max_quantity)

@export var icon:=preload("res://icon.png")
@export var custom_properties:={}

@export var prefab:PackedScene
