extends GOAPAction
class_name ActionFindFood

func name()->StringName:
	return 'action find food'

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:0.5,
	}

func perform(local_state:Dictionary,time:float)->bool:
	return false
