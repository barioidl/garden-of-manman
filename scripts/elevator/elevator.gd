extends Node3D
class_name Elevator

enum axis{x,y,z}
@export var travel_axis:=axis.y

var floor_pos:Array[float]=[]
var floor_locked:Array[bool]=[]

@onready var platform := $platform
@onready var control_panel := $"platform/control panel"
@onready var floor_doors := $"floor doors"

var current_id := -1
var cooldown:=0.0

func _process(delta: float) -> void:
	if cooldown >0:
		cooldown -= delta

func setup_control_panel():
	control_panel.setup_panel(floor_pos.size())

func travel_to_floor(id:int):
	if cooldown > 0:return
#	id = clampi(id,0,floor_pos.size())
	if current_id == id: return
	
	if floor_locked[id]:return
	var pos = floor_pos[id]
	var move_duration := 0.0
	match travel_axis:
		axis.x:
			move_duration = platform.move_x(pos) 
		axis.y:
			move_duration = platform.move_y(pos) 
		axis.z:
			move_duration = platform.move_z(pos) 
	cooldown = move_duration
	
	floor_doors.close(current_id)
	var tween = create_tween()
	if move_duration > 0:
		tween.tween_interval(move_duration)
	tween.tween_callback(floor_doors.open.bind(id))
	
	current_id = id
