extends Node3D

var button = preload("res://scripts/elevator/panel button.tscn")
@onready var elevator := $"../.."
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
