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
		for input in act.get_inputs():
			if !group_inputs.has(input):
				group_inputs[input] = [act]
			else:
				var action_list :Array= group_inputs[input]
				if !action_list.has(act):
					action_list.append(act)
				group_inputs[input] = action_list
func bake_outputs():
	for act in actions:
		for input in act.get_outputs():
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

func get_plan(goal:GOAPGoal,local_state:Dictionary)->Array:
	var desired_result := goal.get_result()
	if desired_result.is_empty(): return[]
	
	return find_best_plan(goal,desired_result,local_state)

func find_best_plan(goal:GOAPGoal, desired_result: Dictionary, local_state:Dictionary)->Array:
	
	return[]

func _get_cheapest_plan():
	pass

func build_plan():
	pass

func print_plan(plan:Array)->String:
	var content :=''
	for step in plan:
		content += step.get_name()
		content += ', '
	return content
