extends Resource
class_name GOAPPlanner

var group_inputs:={}
var group_outputs:={}
var actions:Array=[]:
	get:
		return actions
	set(value):
		actions = value
		bake_inputs()
		bake_outputs()

func bake_inputs():
	for act in actions:
		for input in act.get_inputs({}):
			if !group_inputs.has(input):
				group_inputs[input] = [act]
			else:
				var action_list :Array= group_inputs[input]
				if !action_list.has(act):
					action_list.append(act)
				group_inputs[input] = action_list
func bake_outputs():
	for act in actions:
		for input in act.get_outputs({}):
			if !group_outputs.has(input):
				group_outputs[input] = [act]
			else:
				var action_list :Array= group_outputs[input]
				if !action_list.has(act):
					action_list.append(act)
				group_outputs[input] = action_list

func print_group(group:Dictionary):
	var key = group.keys()
	var values = group.values()
	var iterations:= group.size()
	for i in iterations:
		var actions:=''
		for j in values[i]:
			actions += j.get_name()
			actions += ', '
		print(key[i]+': '+ actions)

func print_plan(plan:Array)->String:
	var content :=''
	for step in plan:
		content += step.name()
		content += ', '
	return content

func get_plan(goal:GOAPGoal,local_state:Dictionary)->Array:
	var desired_result := goal.get_result(local_state). duplicate()
	if desired_result.is_empty(): 
		return[]
	local_state = local_state.duplicate()#make sure it's read-only 
	return find_best_plan(goal, desired_result, local_state)

enum index{conditions,plan,cost}
func find_best_plan(goal:GOAPGoal, desired_result: Dictionary, local_state:Dictionary)->Array:
	var available_plans:=[]
	var generating_plans:=[]
	
	var first_branch:={
		index.conditions:desired_result,
		index.plan:[],
		index.cost:0,
	}
	generating_plans.append(first_branch)
	
	var max_steps :int= local_state[Goap.keys.plan_depth]
	for i in max_steps:
		var iterations = generating_plans.size()
		for id in iterations:
			expand_branch(id, generating_plans, available_plans, local_state)
	
	return select_plan(available_plans,local_state)

func is_conditions_cleared(conditions:Dictionary)->bool:
	var values = conditions.values()
	for i in values:
		if i != 0:
			return false
	return true

func expand_branch(id:int, in_progress:Array, done:Array, local_state: Dictionary):
	var branch = in_progress[id]
	var conditions = branch[index.conditions]
	if is_conditions_cleared(conditions):
		in_progress.remove_at(id)
		done.append(branch)
		return
	
	var unique_actions:=[]
	var iterations = conditions.size()
	var keys = conditions.keys()
	for i in iterations:
		var key = keys[i]
		var actions = get_suitable_actions(i, key, conditions[key], local_state)
		for act in actions:
			if !unique_actions.has(act):
				unique_actions.append(act)
	
	var new_branches = unique_actions.size()
	if new_branches <=0: 
		return
	var act :GOAPAction= unique_actions[0]
	branch[index.plan].append(act)
	
	var outputs = act.get_outputs(local_state)
	for i in iterations:
		var key = keys[i]
		if !outputs.has(key): continue
		conditions[key] -= outputs[key]
		
	var inputs = act.get_inputs(local_state)
	var inputs_size = inputs.size()
	var input_keys = inputs.keys()
	for i in inputs_size:
		var key = input_keys[i]
		if conditions.has(key):
			conditions[key]+= inputs[key]
		else:
			conditions[key] = inputs[key]

#prioritize actions with lowest cost
func get_suitable_actions(id, key, result, local_state: Dictionary)->Array:
	var min_cost:=10000.0
	var actions:=[]
	for act in group_outputs[key]:
		if !act.is_valid(local_state):
			continue#ignore invalid actions
		var output = act.get_outputs(local_state)
		if result * output[key] <= 0:
			continue#ignore unwanted actions
		
		var cost = act.get_cost(local_state)
		if cost < min_cost:
			min_cost = cost
			actions.push_front(act)
		else:
			actions.push_back(act)
	
	var max_options:int=local_state[Goap.keys.plan_width]
	if actions.size() > max_options:
		actions.resize(max_options)
	return actions

func select_plan(available_plans: Array, local_state: Dictionary)->Array:
	var size = available_plans.size()
	if size <= 0: return []
	if size ==1: return available_plans[0][index.plan]
	available_plans.sort_custom(plan_sort)
	
	var max_options:int=local_state[Goap.keys.plan_width]
	max_options = mini(max_options,size)
	var id = randi_range(0,max_options)
	return available_plans[id][index.plan]

func plan_sort(a,b)->bool:
	return a[index.cost] < b[index.cost]


#func build_plan():
#	pass


