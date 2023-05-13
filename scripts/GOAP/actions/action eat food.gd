extends GOAPAction
class_name ActionEatFood
func name()->StringName:
	return 'A eat food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:1,
		}
func get_outputs(self_state:Dictionary)->Dictionary:
	return {
		NameList.has_food:-1,
		NameList.hunger: -1
	}

func perform(agent: GOAPAgent, local_state:Dictionary,time:float)-> bool:
	
	var walk_to = agent.root.get_meta(NameList.get_inputs)
	var input = walk_to.call()
	input.reset()
	return false
