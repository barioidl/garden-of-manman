extends GOAPAction
class_name ActionTakeFoodFromItem

func name()->StringName:
	return 'action take food from item'

func get_cost(self_state:Dictionary)->int:
	return 12

func is_valid(self_state:Dictionary)->bool:
	return false

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:1,
	}
