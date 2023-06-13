extends GOAPGoal
class_name GoalEatFood

func _name() -> StringName:
	return &'G eat food'

func is_valid(local_state:Dictionary)->bool:
	if !local_state.has(NL.hunger):
		return false
	if local_state[NL.hunger] <= 0:
		return false
	return true

func priority(local_state:Dictionary)-> float:
	var root = local_state[NL.root]
	if cache_cost.has(root):
		return cache_cost[root]
		
	var hunger = local_state[NL.hunger]
	var max_hunger = local_state[NL.max_hunger]
	var score = Curves.sample(1,3,hunger/max_hunger)
	score *= get_weight(0)
	
	cache_cost[root] = score
	return score 

func get_result(local_state:Dictionary)->Dictionary:
	return{NL.hunger: -1}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
