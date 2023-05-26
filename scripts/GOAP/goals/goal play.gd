extends GOAPGoal
class_name GoalPlay

func _name() -> StringName:
	return 'G play'

func is_valid(local_state:Dictionary)->bool:
	return true

func priority(local_state:Dictionary)->float:
	return 0.6

func get_result(local_state:Dictionary)->Dictionary:
	return{}
