extends GOAPAction
class_name ActionFight

func name()->StringName:
	return 'A fight'

func is_valid(self_state:Dictionary)->bool:
	return false

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}
