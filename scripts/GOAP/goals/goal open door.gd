extends GOAPGoal
class_name GoalOpenDoor

func _name() -> StringName:
	return &'G open door'

func is_valid(self_state:Dictionary)->bool:
	var agent :GOAPAgent= self_state.agent
	var door = agent.get_closest_node3d(NL.door,10)
	return true

func priority(self_state:Dictionary)->float:
	return 0.5

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.exploration:1
	}
