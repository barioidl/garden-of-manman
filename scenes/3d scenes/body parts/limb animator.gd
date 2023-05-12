extends Node3D
class_name LimbAnimator

@export var container:Node3D
@export var time_scale := 1.0

func _ready() -> void:
	container.connect(NameList.on_state_changed, state_changed)

signal on_state_changed(state)
func state_changed(_state:StringName):
	emit_signal(NameList.on_state_changed,_state)
	match _state:
		NameList.idle:
			return idle()
		NameList.walk:
			return walk()
		NameList.sneak:
			return sneak()
		NameList.sprint:
			return sprint()
		NameList.jump:
			return jump()
		NameList.fall:
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
