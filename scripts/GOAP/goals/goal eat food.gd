extends GOAPGoal
class_name GoalEatFood

func _name() -> StringName:
	return &'G eat food'

func is_valid(self_state:Dictionary)->bool:
	if !self_state.has(NL.hunger):
		return false
	if self_state[NL.hunger] <= 0:
		return false
	return true

func priority(self_state:Dictionary)-> float:
	var hunger = self_state[NL.hunger]
	var max_hunger = self_state[NL.max_hunger]
	var score = Curves.sample(1,3,hunger/max_hunger)
	return score * get_weight(NL.hunger)

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.hunger: -1,
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true
