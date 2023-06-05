extends Node
class_name FPS_Aim

var root:Node3D
var inputs:Inputs
var head:HotbarUser
var body:Node3D

var rotation_body:= 0.0
var rotation_head:=0.0
@export var body_limits:= Vector2.ZERO
@export var head_limits := Vector2(-90.0,90.0)

func _init() -> void:
	name = 'fps_aim'
func _enter_tree() -> void:
	root=$'..'.root
	owner = root
	set_interface()
func _ready():
	inputs = root.get_node('inputs')
	body = root.get_node('body')
	head = body.get_node("head")

func _process(delta: float) -> void:
	rotate_fps(delta)

func rotate_fps(delta):
	if body == null: 
		return
	var axis = inputs.dpad2
	if axis == Vector2.ZERO : 
		return
	rotation_body += axis.x*delta
	if body_limits != Vector2.ZERO:
		rotation_body = clampf(
			rotation_body, 
			body_limits.x, 
			body_limits.y)
	body.rotation_degrees.y = rotation_body
	
	rotation_head = clampf(
		rotation_head + axis.y*delta,
		head_limits.x,
		head_limits.y)
	head.rotation_degrees.x = rotation_head


func set_interface():
	var turn_head = Callable(turn_head_toward)
	root.set_meta(NL.turn_head_toward, turn_head)

func turn_head_toward(target:Vector3, x_speed:= 1.0, y_speed := 1.0)-> bool:
	var local:Vector3=head.to_local(target)
	var x = atan2(local.x, local.z)
	var y = atan2(local.y, local.z)
	
	var matched := true
	if is_equal_approx(x,0):
		inputs.dpad2.x = 0
	else:
		inputs.dpad2.x = rad_to_deg(x) * x_speed * 5
		matched = false
	
	if is_equal_approx(y,0):
		inputs.dpad2.y = 0
	else:
		inputs.dpad2.y = -rad_to_deg(y) * y_speed * 5
		matched = false
	
	return matched
