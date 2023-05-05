extends Resource
class_name GOAPPlanner

var actions:Array=[]:
	get:
		return actions
	set(value):
		actions = value

func get_plan(goal,self_state)->Array:
	return []

func find_best_plan():
	return

func _get_cheapest_plan():
	pass

func build_plan():
	pass

func print_plan():
	pass
