extends GOAPAction
class_name ActionScream

func name()->StringName:
	return 'A scream'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.jumpscare)

func get_cost(local_state:Dictionary)->float:
	return randf_range(0.1,1)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.player_fear:0.2
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var jumpscare = local_state.get(NL.jumpscare)
	jumpscare.scream()
	return true
