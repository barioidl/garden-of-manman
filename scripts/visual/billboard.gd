@tool
extends SpriteBase3D
class_name Billboard3d

@export_category('spite settings')
@export var use_shade:=true
@export var alphacut:=SpriteBase3D.ALPHA_CUT_DISCARD
@export var disable_dist:=30.0

signal rotation_changed()
signal sprite_changed()

@export_category('settings')
enum bill_board_modes{bill_board,lock_y_axis,six_sides}
@export var face_camera:=bill_board_modes.bill_board:
	get:
		return face_camera
	set(value):
		face_camera = value
		set_face_axis()

@export var reference_frame:Node3D
@onready var camera := get_viewport().get_camera_3d()

@export var select_cd_range:=Vector2(0.3,1)
@export var rotate_cd_range:=Vector2(0.1,0.5)
var select_cd:=0.0
var rotate_cd:=0.1

@export var axis_ratio:=Vector3.ONE

var current_side:=-1
enum axises{x,_x,y,_y,z,_z,local}
var axis_forward:=axises.z
var axis_up:=axises.y

var forward := Vector3.ONE 

func _ready() -> void:
	add_to_group('billboard_sprites')
	set_up_sprite()
	set_face_axis()

func _enter_tree() -> void:
	camera = get_viewport().get_camera_3d()
	if reference_frame == null:
		reference_frame = get_parent()

func set_up_sprite():
	set_draw_flag(SpriteBase3D.FLAG_DOUBLE_SIDED, false)
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	shaded = use_shade
	alpha_cut = alphacut

func set_face_axis():
	match face_camera:
		bill_board_modes.bill_board:
			axis = Vector3.AXIS_Z
		bill_board_modes.lock_y_axis:
			axis = Vector3.AXIS_Y
		bill_board_modes.six_sides:
			axis = Vector3.AXIS_Z

func _process(delta: float) -> void:
	if reference_frame == null: return
	if camera == null:return
	if !visible:return
	
	var dir = camera.global_position - global_position
	var dist_ratio = dir.length_squared() / (disable_dist*disable_dist)
	if dist_ratio > 1: return
	forward = dir.normalized()
	
	select_cd -= delta
	if select_cd < 0 and PerformanceCap.allow_billboard_select():
		select_cd = lerpf(select_cd_range.x, select_cd_range.y, dist_ratio)
		rotate_cd = 0
#		camera = get_viewport().get_camera_3d()
		choose_side()
		
	rotate_cd -=delta
	if rotate_cd < 0 and PerformanceCap.allow_billboard_rotate():
		rotate_cd = lerpf(rotate_cd_range.x, rotate_cd_range.y, dist_ratio)
		match face_camera:
			bill_board_modes.bill_board:
				billboard_forward()
			bill_board_modes.lock_y_axis:
				billboard_up()
			bill_board_modes.six_sides:
				axis_rotate()

func choose_side():
	var ref = reference_frame.global_transform.basis

	var x = forward.distance_squared_to(ref.x)-2
	var y = forward.distance_squared_to(ref.y)-2
	var z = forward.distance_squared_to(ref.z)-2
	if axis_ratio != Vector3.ONE:
		x *= axis_ratio.x
		y *= axis_ratio.y
		z *= axis_ratio.z
	
	var maximum = abs(x)
	var cardinal := 0 
	var abs_y = abs(y)
	if maximum < abs_y:
		maximum = abs_y
		cardinal = 1
	var abs_z= abs(z)
	if maximum < abs_z:
		maximum = abs_z
		cardinal = 2
	var deadzone := 1.5
#	print(Vector3(x,y,z))
	match cardinal:
		0:
			if x <0:
				select(3)
				axis_forward = axises._x
				axis_up = axises.y
				return
			else:
				select(1)
				axis_forward = axises.x
				axis_up=axises.y
				return
		1:
			if y <0:
				select(4)
				axis_forward = axises._y
				axis_up=axises._z
				return
			else:
				select(5)
				axis_forward = axises.y
				axis_up=axises.z
				return
		2:
			if z <0:
				select(0)
				axis_forward = axises._z
				axis_up=axises.y
				return
			else:
				select(2)
				axis_forward = axises.z
				axis_up=axises.y
				return
	axis_up=axises.local

func select(side):
	current_side = side
	emit_signal("sprite_changed")

func billboard_forward():
	var up := convert_to_axis(axis_up)
	if up == Vector3.ZERO: return
	if forward == Vector3.ZERO: return
	look_at(global_position - forward*10,up)
	emit_signal("rotation_changed")

func billboard_up():
	var up := convert_to_axis(axis_up)
	look_at(global_position + up*10,forward)
	emit_signal("rotation_changed")

func axis_rotate():
	var forward := convert_to_axis(axis_forward)
	var up := convert_to_axis(axis_up)
	look_at(global_position+forward*10,up)
	emit_signal("rotation_changed")

func convert_to_axis(_axis)->Vector3:
	var ref_basis = reference_frame.global_transform.basis
	match  _axis:
		axises.x:
			return ref_basis.x
		axises._x:
			return -ref_basis.x
		axises.y:
			return ref_basis.y
		axises._y:
			return -ref_basis.y
		axises.z:
			return ref_basis.z
		axises._z:
			return -ref_basis.z
		axises.local:
			return basis.y
	return basis.y
