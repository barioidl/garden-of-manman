extends GOAPGoal
class_name GoalSurvive

func name() -> StringName:
	return 'goal survive'

func is_valid(self_state:Dictionary)->bool:
	return true

func priority(self_state:Dictionary)->int:
	return 1

func get_result(self_state:Dictionary)->Dictionary:
	return{
		Goap.keys.health:1,
	}
