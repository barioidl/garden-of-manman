extends GOAPGoal
class_name GoalEatFood

func name() -> StringName:
	return 'G eat food'

func is_valid(self_state:Dictionary)->bool:
	return true

func priority(self_state:Dictionary)->int:
	return 3

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.hunger:-1,
	}
