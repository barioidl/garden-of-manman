extends Node3D

func open(id:int):
	get_child(id).slide(true)

func close(id:int):
	get_child(id).slide(false)

