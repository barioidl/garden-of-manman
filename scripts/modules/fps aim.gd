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
	root.set_meta(NameList.turn_head_toward, turn_head)

func turn_head_toward(target:Vector3, turn_speed:=1.0):
	var local:Vector3=head.to_local(target)
	local.z = 0
	local = local.normalized()
	var x = clampf(local.x * 10,-1,1)
	var y = clampf(local.y * 10,-1,1)
	input.dpad2.x = x * turn_speed * 50
	input.dpad2.y = -y * turn_speed * 50
