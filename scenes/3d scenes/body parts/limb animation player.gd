extends AnimationPlayer

func play_state(_state:StringName, timescale:float, flip:=false)->bool:
	_state = combine_animations(_state)
	if flip:
		_state+='_flip'
	speed_scale = timescale
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
