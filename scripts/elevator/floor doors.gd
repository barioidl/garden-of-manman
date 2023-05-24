extends Node3D

func open(id:int):
	var slider = get_child(id).get_child(0)
	slider.slide(true)

func close(id:int):
	var slider = get_child(id).get_child(0)
	slider.slide(false)
