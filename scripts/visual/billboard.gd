@tool
extends SpriteBase3D
class_name Billboard3d

@export_category('material settings')
@export var use_shade:=true
@export var has_shadow:= true
@export var alphacut:=SpriteBase3D.ALPHA_CUT_DISCARD
@export var disable_dist:=30.0

@export_category('billboard settings')
enum bill_board_modes{bill_board,lock_y_axis,six_sides}
@export var face_camera:=bill_board_modes.bill_board:
	get:
		return face_camera
	set(value):
		face_camera = value
		set_face_axis()

@export var reference_frame:Node3D
@onready var camera := get_viewport().get_camera_3d()

@export var select_cd_range:=Vector2(0.1,.5)
@export var rotate_cd_range:=Vector2(0.02,0.2)
var select_cd:=0.0
var rotate_cd:=0.1

@export var axis_ratio:=Vector3.ONE

signal rotation_changed()
signal sprite_changed()

var current_side:=0
enum axises{x,_x,y,_y,z,_z,local}
var axis_forward:=axises.z
var axis_up:=axises.y

var forward := Vector3.ONE 

func _ready() -> void:
	if NL.is_inside_tree():
		add_to_group(NL.billboard_sprites)
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
	transparent = true
	
	if has_shadow:
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
	else:
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

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
	
	var cam_forward = camera.global_transform.basis.z
	if cam_forward.dot(dir) < 0: return
	
	var dist_ratio = dir.length_squared() / (disable_dist * disable_dist)
	if dist_ratio > 1: return
	forward = dir.normalized()
	
	select_sprite(delta,dist_ratio)
	rotate_sprite(delta,dist_ratio)

func select_sprite(delta,dist_ratio):
	if select_cd > 0:
		select_cd -= delta
		return
	if !PerformanceCap.allow_billboard_select():
		return
	select_cd = lerpf(select_cd_range.x, select_cd_range.y, dist_ratio)
	choose_side()

func rotate_sprite(delta,dist_ratio):
	if rotate_cd > 0:
		rotate_cd -= delta
		return
	if !PerformanceCap.allow_billboard_rotate():
		return
	rotate_cd = lerpf(rotate_cd_range.x, rotate_cd_range.y, dist_ratio)
	match face_camera:
		bill_board_modes.bill_board:
			billboard_forward()
		bill_board_modes.lock_y_axis:
			billboard_up()
		bill_board_modes.six_sides:
			axis_rotate()

func choose_side():
	var dist_axis := reference_frame.to_local(camera.global_position)
	if axis_ratio != Vector3.ONE:
		dist_axis = dist_axis * axis_ratio
	var max_axis = dist_axis.abs().max_axis_index()
	match max_axis:
		Vector3.AXIS_X:
			select_x(dist_axis.x)
			return
		Vector3.AXIS_Y:
			select_y(dist_axis.y)
			return
		Vector3.AXIS_Z:
			select_z(dist_axis.z)
			return
	axis_up=axises.local

func select_x(dist_axis:float):
	if dist_axis > 0:
		select(3)
		axis_forward = axises._x
		axis_up = axises.y
	else:
		select(1)
		axis_forward = axises.x
		axis_up=axises.y
func select_y(dist_axis:float):
	if dist_axis > 0:
		select(4)
		axis_forward = axises._y
		axis_up=axises._z
	else:
		select(5)
		axis_forward = axises.y
		axis_up=axises.z
func select_z(dist_axis:float):
	if dist_axis > 0:
		select(0)
		axis_forward = axises._z
		axis_up=axises.y
	else:
		select(2)
		axis_forward = axises.z
		axis_up=axises.y



func select(side):
	current_side = side
	emit_signal("sprite_changed")

func billboard_forward():
	var up := convert_to_axis(axis_up)
	if !is_axis_valid(forward,up): return
	
	look_at(global_position - forward , up)
	emit_signal("rotation_changed")

func billboard_up():
	var up := convert_to_axis(axis_up)
	if !is_axis_valid(forward,up): return
	
	look_at(global_position + up, forward)
	emit_signal("rotation_changed")

func axis_rotate():
	var forward := convert_to_axis(axis_forward)
	var up := convert_to_axis(axis_up)
	if !is_axis_valid(forward,up): return
	
	look_at(global_position + forward, up)
	emit_signal("rotation_changed")

func is_axis_valid(forward,up) -> bool:
	if up == Vector3.ZERO: return false
	if forward == Vector3.ZERO: return false
#	if up.angle_to(forward) < 0.1: return false
	return true

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
