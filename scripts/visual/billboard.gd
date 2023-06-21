@tool
extends Node3D
class_name Billboard3d

enum bill_board_modes{bill_board, lock_y_axis, six_sides}
@export var face_camera:=bill_board_modes.bill_board:
	get:
		return face_camera
	set(value):
		face_camera = value

@export var disable_dist:=30.0
@export var reference_frame:Node3D
var camera :Camera3D

@export var cd_range:=Vector2(0.02,0.5)
var cooldown:=0.2

@export var axis_ratio:=Vector3.ONE

signal rotation_changed()
signal sprite_changed()

var current_side:=0
enum axises{x,_x,y,_y,z,_z,local}
var axis_forward:=axises.z
var axis_up:=axises.x

var forward := Vector3.ONE 
var prev_dir:=Vector3.ZERO

func _ready() -> void:
	if NL.is_inside_tree():
		add_to_group(NL.billboard_sprites)

func _enter_tree() -> void:
	camera = get_viewport().get_camera_3d()
	if reference_frame == null:
		reference_frame = get_parent()

func _process(delta: float) -> void:
	if reference_frame == null: return
	if camera == null:return
	
	if cooldown > 0:
		cooldown -= delta
		return
	if !PerformanceCap.allow_billboard():	return
	
	var dir = camera.global_position - global_position
	var dist_ratio = dir.length_squared() / (disable_dist * disable_dist)
	if dist_ratio > 1: return
	if dir.distance_squared_to(prev_dir) < 0.1 * dist_ratio:
		return
	prev_dir = dir
	
	forward = dir.normalized()
	cooldown = lerpf(cd_range.x, cd_range.y, dist_ratio)
	select_sprite(delta)
	rotate_sprite(delta)

var select_counter := 1
func select_sprite(delta):
	if select_counter > 0:
		select_counter -= 1
		return
	select_counter = 3
	choose_side()

func rotate_sprite(delta):
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
	match _axis:
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
	return basis.y
