extends Node3D
class_name Elevator

enum axis{x,y,z}
@export var travel_axis:=axis.y

var floor_pos:Array[float]=[]
var floor_locked:Array[bool]=[]

@onready var platform := $platform
@onready var control_panel := $"platform/control panel"

var cooldown:=0.0
#func _ready() -> void:
#	pass 
#
func _process(delta: float) -> void:
	if cooldown >0:
		cooldown -= delta

func setup_control_panel():
	control_panel.setup_panel(floor_pos.size())
	
func travel_to_floor(id:int):
	if cooldown > 0:
		return
	id = clampi(id,0,floor_pos.size())
	if floor_locked[id]:
		return
	var pos = floor_pos[id]
	match travel_axis:
		axis.x:
			platform.move_x(pos) 
		axis.y:
			platform.move_y(pos) 
		axis.z:
			platform.move_z(pos) 
