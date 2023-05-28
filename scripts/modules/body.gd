extends Node3D

var root:Node3D

func _init() -> void:
	name = 'body'

func _enter_tree() -> void:
	root=$"..".root
	owner = root

func _process(delta: float) -> void:
	root.custom_transform = global_transform
