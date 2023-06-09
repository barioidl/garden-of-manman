extends Node3D

var button = preload("res://scripts/elevator/panel button.tscn")
@onready var elevator := $"../.."

func _ready() -> void:
	add_to_group(NL.elevator_panels)
	set_meta(NL.use_elevator,use_elevator)

func use_elevator(pos:Vector3):
	pos = elevator.to_local(pos).floor()
	var axis_pos:float
	var axis = elevator.axis
	match elevator.travel_axis:
		axis.x:
			axis_pos = pos.x
		axis.y:
			axis_pos = pos.y
		axis.z:
			axis_pos = pos.z
	
	var target_floor := 0
	var floor_pos = elevator.floor_pos
	for i in floor_pos.size():
		var floor_position = floor_pos[i]
		if floor_position > axis_pos:
			break
		target_floor = i
	get_child(target_floor).toggle()


func setup_panel(floors:int):
	for i in floors:
		var locked = elevator.floor_locked[i]
		create_button(i,locked)

func create_button(id:int,locked:bool):
	var child = button.instantiate()
	var button_height:float=id*0.5
	child.position = Vector3(0,button_height,0)
	child.locked = locked
	child.connect(NL.pressed,button_pressed.bind(id))
	add_child(child)

func button_pressed(id:int):
	elevator.travel_to_floor(id)
