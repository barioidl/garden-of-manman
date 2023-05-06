extends GOAPGoal
class_name GoalSurvive

func name() -> String:
	return 'survive'

func is_valid()->bool:
	return true

func priority()->int:
	return 3

func get_result()->Dictionary:
	return{
		Goap.keys.is_hungry:false,
		Goap.keys.is_low_hp:false,
		Goap.keys.is_in_danger:false,
	}
