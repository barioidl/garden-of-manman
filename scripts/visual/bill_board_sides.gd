@tool
extends Resource
class_name BillboardSides

@export var frames:Array[Texture]=[]
var max_frame:=0

func init():
	max_frame = frames.size()

func change_frame(steps:=0):
	pass

func get_sprite(side:=0)->Texture:
	if max_frame <= 0:
		return null
	side = wrapi(side,0,max_frame)
	return frames[side]
