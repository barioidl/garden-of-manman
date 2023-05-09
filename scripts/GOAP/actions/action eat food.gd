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
		NameList.hunger: -0.5
	}

func perform(local_state:Dictionary,time:float)->bool:
	return false
