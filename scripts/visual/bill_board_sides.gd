@tool
extends Resource
class_name BillboardSides

@export var frames:Array[Texture]=[]
var max_frame:=0

func _init() -> void:
	max_frame = frames.size()

func get_sprite(side:=0)->Texture:
	if max_frame <= 0:
		return null
#	side = wrapi(side,0,max_frame)
	return frames[side]
