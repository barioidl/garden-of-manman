extends Node3D
class_name ButtonAnimation

var duration = 0.5
@export var transition:Tween.TransitionType
@onready var button = $".."
func _ready():
	button.connect("toggled",_button_toggled.bind())

func _button_toggled(button_pressed) -> void:
	button.cooldown = duration
	play_animation(button_pressed)
	play_sound()

func play_animation(button_pressed):
	var _in = Vector3(0.1,0,0)
	var _out = Vector3(0.2,0,0)
	var tween = create_tween()
	tween.tween_property(self,'position',_in, duration*0.5).set_trans(transition)
	tween.tween_property(self,'position',_out, duration*0.5).set_trans(transition)

@export var sfx_list:AudioList
func play_sound():
	var pos = global_position
	AudioPool.create_sound_3d(pos,sfx_list)
