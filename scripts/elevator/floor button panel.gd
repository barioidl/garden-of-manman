extends Node3D

@onready var elevator :Elevator= get_parent()

func _ready() -> void:
	setup_panel()
	elevator.call_deferred('setup_control_panel')

func setup_panel():
	var floor_count = get_child_count()
	var floor_pos :Array[float]= []
	var floor_locked :Array[bool]=[]
	floor_pos.resize(floor_count)
	floor_locked.resize(floor_count)
	
	for i in floor_count:
		var button = get_child(i)
		button.connect('pressed',button_pressed.bind(i))
		floor_pos[i] = get_floor_pos(button)
		floor_locked[i] = button.locked
	elevator.floor_pos = floor_pos
	elevator.floor_locked = floor_locked
	

func get_floor_pos(button:Node3D)->float:
	var pos :Vector3= button.offset_pos
	pos = button.to_global(pos)
	pos = elevator.to_local(pos)
	match elevator.travel_axis:
		elevator.axis.x:
			return pos.x
		elevator.axis.y:
			return pos.y
		elevator.axis.z:
			return pos.z
	return 0

func button_pressed(id:int):
	elevator.travel_to_floor(id)
