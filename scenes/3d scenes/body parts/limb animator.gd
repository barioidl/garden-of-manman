extends Node
class_name LimbAnimator

@export var rig:Node3D

func _ready() -> void:
	rig.connect(NameList.on_state_changed, on_state_changed)

func on_state_changed(state:StringName):
	match state:
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
