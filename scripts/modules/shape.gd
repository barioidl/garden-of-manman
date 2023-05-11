extends CollisionShape3D

@onready var root = get_parent().root
@onready var platformer=$'../platformer'

@export var duration :=0.1
@export var transition := Tween.TRANS_SINE
@export var average_size:=Vector3(0.8, 2.0, 0.8)

@export_category('platformer sizes')
@export var walk_size:= Vector3(1, 1, 1)
@export var sneak_size:= Vector3(1.2, 0.7, 1.2)
@export var sprint_size:= Vector3(1, 0.9, 1)
@export var jump_size:= Vector3(0.9, 1.1, 0.9)
@export var fall_size:= Vector3(1, 1, 1)


func _init() -> void:
	name = 'shape'
func _ready() -> void:
	owner = root
	
	platformer.connect(NameList.on_state_changed, on_state_changed)

func on_state_changed(state:StringName):
	var size = get_shape_scale(state)
	size *= average_size
	change_shape_size(size)

func get_shape_scale(state)->Vector3:
	match state:
		NameList.walk:
			return walk_size
		NameList.sneak:
			return sneak_size
		NameList.sprint:
			return sprint_size
		NameList.jump:
			return jump_size
		NameList.fall:
			return fall_size
	
	return Vector3.ONE

signal on_size_changed(size:Vector3)
func change_shape_size(_size:Vector3):
	emit_signal('on_size_changed',_size)
	if shape is CapsuleShape3D:
		change_capsule_size(_size)
		return
	if shape is BoxShape3D:
		change_box_size(_size)
		return

func change_box_size(_size:Vector3):
	var tween_pos = create_tween()
	var tween_size = create_tween()
	tween_pos.tween_property(self,"position:y", _size.y * 0.5, duration).set_trans(transition)
	"size"
	
	tween_size.tween_property(shape,"size", _size, duration).set_trans(transition)

func change_capsule_size(_size:Vector3):
	var tween_pos = create_tween()
	var tween_radius = create_tween()
	var tween_size = create_tween()
	tween_pos.tween_property(self,"position:y", _size.y * 0.5, duration).set_trans(transition)
	
	var radius:= (_size.x + _size.z) * 0.5
	tween_radius.tween_property(shape,"radius", radius, duration).set_trans(transition)
	tween_size.tween_property(shape,"height", _size.y, duration).set_trans(transition)
	
