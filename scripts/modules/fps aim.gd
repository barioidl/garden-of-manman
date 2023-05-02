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
	root.add_to_group('fps_aim')

func _process(delta: float) -> void:
	rotate_fps(delta)

func rotate_fps(delta):
	if body == null: return
	var axis = input.dpad2
	if axis == Vector2.ZERO : return
	rotation_body += axis.x*delta
	if body_limits != Vector2.ZERO:
		rotation_body = clampf(rotation_body,body_limits.x,body_limits.y)
	body.rotation_degrees.y = rotation_body
	
	rotation_head = clampf(
		rotation_head + axis.y*delta,
		head_limits.x,
		head_limits.y
		)
	head.rotation_degrees.x = rotation_head
