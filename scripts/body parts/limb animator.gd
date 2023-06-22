extends Node3D
class_name LimbAnimator

@export var container:Node3D
@export var time_scale := 1.0

func _ready() -> void:
	container.connect(NL.on_state_changed, state_changed)

signal on_state_changed(state)
func state_changed(_state:StringName):
	emit_signal(NL.on_state_changed,_state)
	match _state:
		NL.idle:
			return idle()
		NL.walk:
			return walk()
		NL.sneak:
			return sneak()
		NL.sprint:
			return sprint()
		NL.jump:
			return jump()
		NL.fall:
			return fall()

func idle():
	pass

func walk():
	pass

func sneak():
	pass
	
func sprint():
	pass

func jump():
	pass

func fall():
	pass
