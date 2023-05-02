extends CollisionShape3D

@onready var root:=$'..'
@onready var platformer=$'../platformer'
#@onready var mesh:=$mesh

@export var normal_height:= 2.0
@export var crouch_height:= 1.4
signal position_changed(pos)
func _init() -> void:
	name = 'shape'
func _ready() -> void:
	owner = root
	platformer.connect("on_state_changed",on_state_changed.bind())

func on_state_changed(state):
	var tween = get_tree().create_tween()
	var is_sneaking = state == platformer.states.sneak
	var start = old_value
	var end = crouch_height if is_sneaking else normal_height
	tween.tween_method(set_height, start, end, 0.1).set_trans(Tween.TRANS_SINE)
	
var old_value:=position.y
func set_height(value):
	old_value = value
	shape.height = value
#	position.y = value*0.5
#	emit_signal('position_changed',position)
#	mesh.mesh.height = value
