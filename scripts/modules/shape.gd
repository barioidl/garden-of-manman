extends CollisionShape3D

@onready var root:=$'..'
#@onready var platformer=$'../platformer'
#
#@export var normal_height:= 2.0
#@export var crouch_height:= 1.4
#signal position_changed(pos)
func _init() -> void:
	name = 'shape'
func _ready() -> void:
	owner = root
#	platformer.connect(NameList.on_state_changed,on_state_changed.bind())

#func on_state_changed(state):
#	var tween = get_tree().create_tween()
#	var is_sneaking = state == platformer.states.sneak
#	var end = crouch_height if is_sneaking else normal_height
#	tween.tween_property(shape,"height", end, 0.1).set_trans(Tween.TRANS_SINE)
#	tween.tween_property(self,"position:y", end*0.5, 0.1).set_trans(Tween.TRANS_SINE)
