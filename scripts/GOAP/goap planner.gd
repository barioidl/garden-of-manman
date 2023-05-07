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
		content += step.get_name()
		content += ', '
	return content

func get_plan(goal:GOAPGoal,local_state:Dictionary)->Array:
	var desired_result := goal.get_result(local_state).duplicate(true)
	if desired_result.is_empty(): 
		return[]
	return find_best_plan(goal, desired_result, local_state)

func find_best_plan(goal:GOAPGoal, desired_result: Dictionary, local_state:Dictionary)->Array:
#	var available_plans:=[]
#	var generating_plans:=[]
	
	var first_branch:={}
	first_branch.desired_result = desired_result. duplicate(true)
	first_branch.plan = []
	
	var kill_switch:= 1
	while !first_branch.desired_result.is_empty():
		kill_switch -= 1
		if kill_switch <0:break
		
		var iterations = first_branch.desired_result.size()
		var keys = first_branch.desired_result.keys()
		var values = first_branch.desired_result.values()
#		shoose_suitable_actions(keys[0],values[0])
#			print(keys[i])
#			print(values[i])
	
		
	return[]
func shoose_suitable_actions(key,result)->Array:
	var action
	for j in group_outputs[key]:
		pass
	return action

func _get_cheapest_plan():
	pass



#func build_plan():
#	pass


