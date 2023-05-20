extends Node
class_name ik_constraint

@export var relative:=true
@export var min_angles:=Vector3(-90,-90,-90)
@export var max_angles:=Vector3(90,90,90)

@export var weight := 1.0
@export var max_speed := 10.0

func _init() -> void:
	name = 'ik_constraint'
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	weight = clampf(weight,0,1)
	if !relative:return
	var parent = get_parent()
	var deg = parent.rotation_degrees
	min_angles += deg
	max_angles += deg
