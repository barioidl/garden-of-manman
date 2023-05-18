extends GOAPGoal
class_name GoalEatFood

var priority_curve := Curve.new()
func _init() -> void: 
	priority_curve.add_point(Vector2.ZERO,1,1)
	priority_curve.add_point(Vector2.ONE,3,3)

func name() -> StringName:
	return 'G eat food'

func is_valid(self_state:Dictionary)->bool:
	var valid = self_state.root.has_meta(NL.change_hunger)
	print('valid: '+ str(valid))
	return valid

func priority(self_state:Dictionary)-> float:
	var hunger = self_state[NL.hunger]
	var max_hunger = self_state[NL.max_hunger]
	var score = priority_curve.sample(hunger/max_hunger)
	print('score: ' + str(score))
	return score

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.hunger: -1,
	}
