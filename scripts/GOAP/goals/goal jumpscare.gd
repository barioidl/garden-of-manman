extends GOAPGoal
class_name GoalJumpscare

var priority_curve := Curve.new()
func _init() -> void: 
	priority_curve.add_point(Vector2.ZERO,1,1)
	priority_curve.add_point(Vector2.ONE,3,3)

func name() -> StringName:
	return 'G jumpscare'

func priority(self_state:Dictionary)-> float:
	var hunger = self_state[NL.hunger]
	var max_hunger = self_state[NL.max_hunger]
	var score = priority_curve.sample(hunger/max_hunger)
	return score
