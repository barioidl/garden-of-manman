extends GOAPAction
class_name ActionTurnTargetHead

func name()->StringName:
	return 'A turn target head'

func is_valid(local_state:Dictionary)->bool:
	return true#local_state.has(NL.jumpscare)

func get_cost(local_state:Dictionary)->float:
	return randf_range(0.1,1)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.player_fear:0.3
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var target = local_state.get(NL.jumpscare).target
	var heads_pos = local_state[NL.head].global_position
	return Interface.turn_head(target,heads_pos,4)
