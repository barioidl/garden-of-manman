extends Node
class_name ItemStartup

@onready var root:RigidCharacter=$'..'
@export var items:Array[ItemData]=[]

func _ready() -> void:
	for item in items:
		give_item(item)
	queue_free()

func give_item(item:ItemData):
	if item == null: return
	item = item.duplicate()
	var append_item = root.get_meta('append_item')
	if append_item == null:return
	var added = append_item.call(item)
