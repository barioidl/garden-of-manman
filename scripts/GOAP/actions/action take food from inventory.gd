extends GOAPAction
class_name ActionTakeFoodFromItem

func name()->StringName:
	return 'action take food from item'

func get_cost(self_state:Dictionary)->int:
	return 12

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		Goap.keys.has_food:1,
	}
