extends Resource
class_name GOAPGoal

func _name() -> StringName:
	return 'default_goal'

func is_valid()->bool:
	return true

func priority()->int:
	return 1

func get_result()->Dictionary:
	return{}
