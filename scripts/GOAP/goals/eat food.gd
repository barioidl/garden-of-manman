extends GOAPGoal
class_name GoalEatFood

func name() -> String:
	return 'eat food'

func is_valid()->bool:
	return true

func priority()->int:
	return 3

func get_result()->Dictionary:
	return{
		Goap.keys.is_hungry:-1,
	}
