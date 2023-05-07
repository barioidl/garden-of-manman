extends GOAPAction
class_name ActionEatFood
func name()->StringName:
	return 'action eat food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		Goap.keys.has_food:1,
		}
func get_outputs(self_state:Dictionary)->Dictionary:
	return {
		Goap.keys.hungriness: -0.5
	}
