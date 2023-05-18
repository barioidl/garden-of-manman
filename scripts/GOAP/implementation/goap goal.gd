extends Resource
class_name GOAPGoal

func name() -> StringName:
	return 'default goal'

func is_valid(self_state:Dictionary)->bool:
	return true

func priority(self_state:Dictionary)->float:
	return 1

func get_result(self_state:Dictionary)->Dictionary:
	return{}
