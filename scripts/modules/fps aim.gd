extends Node

@onready var root=$'..'.root
@onready var input = $'../inputs'
@onready var head = $'../body/head'
@onready var body = $'../body'

var rotation_body:= 0.0
var rotation_head:=0.0
@export var body_limits:= Vector2.ZERO
@export var head_limits := Vector2(-90.0,90.0)

func _init() -> void:
	name = 'fps_aim'
func _ready():
	owner = root
	set_interface()

func _process(delta: float) -> void:
	rotate_fps(delta)

func rotate_fps(delta):
	if body == null: 
		return
	var axis = input.dpad2
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

func turn_head_toward(target:Vector3, turn_speed:=1.0)-> bool:
	var local:Vector3=head.to_local(target)
	var x = atan2(local.x, local.z)
	var y = atan2(local.y, local.z)
	
	if is_equal_approx(x,0) and is_equal_approx(y,0):
		input.dpad2 = Vector2.ZERO
		return true
	
	input.dpad2.x = rad_to_deg(x) * turn_speed * 5
	input.dpad2.y = -rad_to_deg(y) * turn_speed * 5
	return false
