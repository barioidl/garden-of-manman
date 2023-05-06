extends Node
class_name GOAPAction

func get_name()->StringName:
	return 'default action'

func is_valid()->bool:
	return true

func get_cost(self_state:Dictionary)->int:
	return 10

func get_inputs()->Dictionary:
	return{}

func get_outputs()->Dictionary:
	return{}
