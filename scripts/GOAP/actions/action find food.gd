extends GOAPAction
class_name ActionFindFood

func name()->StringName:
	return 'action find food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		Goap.keys.has_food:0.5,
	}
