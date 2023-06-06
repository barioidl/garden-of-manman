extends GOAPGoal
class_name GoalEatFood

func _name() -> StringName:
	return &'G eat food'

func is_valid(self_state:Dictionary)->bool:
	if !self_state.has(NL.hunger):
		return false
	if self_state[NL.hunger] <= 0:
		return false
	_print('hungry')
	return true

func priority(self_state:Dictionary)-> float:
	var hunger = self_state[NL.hunger]
	var max_hunger = self_state[NL.max_hunger]
	var score = Curves.sample(1,3,hunger/max_hunger)
	_print(str(score))
	return score * get_weight(0)

func get_result(self_state:Dictionary)->Dictionary:
	return{NL.hunger: -1}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
