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
		NL.walk:
			return NL.walk
		NL.sneak:
			return NL.walk
		NL.sprint:
			return NL.walk
	return _state
