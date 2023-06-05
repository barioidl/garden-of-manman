extends GOAPAction
class_name ActionTakeFoodFromItem

func _name()->StringName:
	return &'A take food from item'

func is_valid(self_state:Dictionary)->bool:
	return false

func get_cost(self_state:Dictionary)-> float:
	return 1

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		NL.has_food:1,
	}
