extends GOAPGoal
class_name GoalFlee

func _name() -> StringName:
	return &'G flee'

func is_valid(self_state:Dictionary)->bool:
	return true

func priority(self_state:Dictionary)->float:
	return 0.5

func get_result(self_state:Dictionary)->Dictionary:
	return{
	}
