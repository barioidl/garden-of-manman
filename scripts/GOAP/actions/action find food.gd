extends GOAPAction
class_name ActionFindFood

func name()->StringName:
	return 'A find food'

func get_cost(self_state:Dictionary)->int:
	return 10

func get_inputs(self_state:Dictionary)->Dictionary:
	return{
		}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{
		NameList.has_food:1,
	}

func perform(agent: GOAPAgent, local_state:Dictionary,time:float)->bool:
	var root :Node3D= agent.root
	var root_pos :Vector3= root.global_position
	var food
	if local_state.has(NameList.food):
		food = local_state[NameList.food]
	if food == null:
		food = WorldState.get_closest_node_3d(NameList.food, root_pos)
		local_state[NameList.food] = food
#	check again
	if food == null:
		return false
	var food_pos = food.global_position
	var dist_sq = root_pos.distance_squared_to(food_pos)
	if dist_sq < 2 * 2:
		return true
	var walk_to = root.get_meta( NameList.walk_to_target)
	walk_to.call(food_pos)
	var face_to = root.get_meta(NameList.turn_head_toward)
	face_to.call(food_pos)
	return false
