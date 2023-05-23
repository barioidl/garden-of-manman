extends Node3D

var button = preload("res://scripts/elevator/panel button.tscn")
@onready var elevator := $"../.."
func setup_panel(floors:int):
	for i in floors:
		create_button(i)

func create_button(id:int):
	var child = button.instantiate()
	add_child(child)
	var button_height:float=id*0.5
	child.position = Vector3(0,button_height,0)
	
	child.connect(NL.pressed,button_pressed.bind(id))

func button_pressed(id:int):
	elevator.travel_to_floor(id)
