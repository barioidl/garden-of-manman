extends GOAPGoal
class_name GoalEatFood


func name() -> StringName:
	return 'G eat food'

func is_valid(self_state:Dictionary)->bool:
	var valid = self_state.root.has_meta(NL.change_hunger)
	return valid

func priority(self_state:Dictionary)-> float:
	var hunger = self_state[NL.hunger]
	var max_hunger = self_state[NL.max_hunger]
	
	var score = Curves.sample(1,3,hunger/max_hunger)
	return score

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.hunger: -1,
	}
