extends AnimationPlayer

var container:Node3D

func play_state(_state:StringName, _duration:float)->bool:
	_state = combine_animations(_state)
	if container.mirrored:
		_state+='_flip'
	speed_scale = 1 / _duration
	play(_state)
	return true

func combine_animations(_state:StringName)->StringName:
	match _state:
		NameList.walk:
			return NameList.walk
		NameList.sneak:
			return NameList.walk
		NameList.sprint:
			return NameList.walk
	return _state
