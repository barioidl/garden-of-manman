extends GOAPAction
class_name ActionEatFood
func name()->StringName:
	return 'action eat food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:1,
		}
func get_outputs(self_state:Dictionary)->Dictionary:
	return {
		NameList.hunger: -0.5
	}
