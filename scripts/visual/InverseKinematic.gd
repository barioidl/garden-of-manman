#@tool
extends Node3D
class_name CCDIK

@export var target:Node3D
@export var chain_length:=2
@export var copy_rotation:=false
@export var joints_per_frame:= 3
@export var solve_backward:= true
@export var average_weight:=0.8
@export var accuracy:=0.05

var chain_nodes:=Array()
var constraints:=Array()

func _ready() -> void:
	average_weight = clampf(average_weight,0,1)
	set_up()

var dt :=0.0
func _process(delta: float) -> void:
	dt = delta
	solve()
	reset_joint_scales()


func set_up():
	var node = get_parent()
	for i in chain_length:
		chain_nodes.append(node) 
		var constraint = node.get_node_or_null('ik_constraint')
		constraints.append(constraint)
		
		node = node.get_parent()
		if !(node is Node3D):	break
		if node == get_node('/root'):	break
	
	var node_count = chain_nodes.size()
	if chain_length>node_count:
		chain_length = node_count
		print('chain length is too long')

func get_total_length()->float:
	var total_length:= position.length()
	for i in chain_length-1:
		var joint = chain_nodes[i]
		total_length += joint.position.length()
	return total_length

var reset_scale_cd:=0.0
func reset_joint_scales():
	if reset_scale_cd >0:
		reset_scale_cd -= dt
		return
	reset_scale_cd = 1
	for joint in chain_nodes:
		joint.scale = Vector3.ONE

var current_joint_id:=0
func solve():
	if target == null:return
	var dist_sq = target.global_position.distance_squared_to(global_position)
	if dist_sq < accuracy: return
	if !PerformanceCap.allow_IK(): return
	
	var start := 1 if copy_rotation else 0
	if copy_rotation and current_joint_id == start:
		copy_target_rotation()
	for i in joints_per_frame:
		if solve_backward:
			current_joint_id +=1
		else:
			current_joint_id -=1
		current_joint_id = wrapi(current_joint_id, start, chain_length)
		solve_joint(current_joint_id)

func solve_joint(i:int):
	var joint :Node3D= chain_nodes[i]
	var constraint :ik_constraint= constraints[i]
	#rotate to target
	var e_i:Vector3=global_position-joint.global_position
	var t_i:Vector3=target.global_position-joint.global_position
	var angle = e_i.angle_to(t_i)
	
	if constraint != null:
		var max_speed = constraint.max_speed
		var weight = constraint.weight * average_weight
		angle = clampf(angle*weight, 0, max_speed)
	if angle < (accuracy):return
	joint.global_rotate(e_i.cross(t_i).normalized(), angle)
	#clamp axis
	if constraint == null: return
	var rot_deg :Vector3= joint.rotation_degrees
	var min_angles = constraint.min_angles
	var max_angles = constraint.max_angles
	joint.rotation_degrees = rot_deg.clamp(min_angles, max_angles)

func copy_target_rotation():
	var tip = chain_nodes[0]
	tip.global_rotation = target.global_rotation
	var constraint = constraints[0]
	if constraint == null:return
	var rotation_deg :Vector3= tip.rotation_degrees
	var min_angles = constraint.min_angles
	var max_angles = constraint.max_angles
	tip.rotation_degrees = rotation_deg.clamp(min_angles,max_angles)
