extends AnimatableBody3D

@onready var elevator = $".."
@onready var nav_link = $"navmesh/nav link"
@export var doors :Array[NodePath]=[]

@onready var original_pos:=position
@export var speed := 1.0

@export var slide_sfx :AudioList
signal elevator_start
signal elevator_stop

func move_x(pos:float)->float:
	return move_platform(position.x,pos,'position:x')
func move_y(pos:float)->float:
	return move_platform(position.y,pos,'position:y')
func move_z(pos:float)->float:
	return move_platform(position.z,pos,'position:z')

var tween:Tween
func move_platform(from,to,property)->float:
	if is_equal_approx(from,to):
		slide_doors(true)
		return 0
	var travel_duration :float= abs(to - from)
	travel_duration /= speed
	var door_duration = get_node(doors[0]).duration
	
	tween = create_tween()
	tween.tween_callback(slide_doors.bind(false))
	tween.tween_interval(door_duration)
	tween.tween_callback(emit_signal.bind("elevator_start"))
	tween.tween_property(self,property,to,travel_duration)
	tween.tween_callback(emit_signal.bind("elevator_stop"))
	tween.tween_callback(slide_doors.bind(true))
	return travel_duration + door_duration

func slide_doors(open:bool):
	nav_link.enabled = open
	for path in doors:
		var door = get_node_or_null(path)
		if door == null:
			continue
		door.slide(open)
		var pos = door.global_position
		AudioPool.create_sound_3d(pos, slide_sfx)
