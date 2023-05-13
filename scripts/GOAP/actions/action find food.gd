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

func perform(agent: GOAPAgent, local_state:Dictionary,time:float)-> bool:
	var root :Node3D= agent.root
	var food = get_food(root,local_state)
#	check again
	if food == null:
		return false
	var food_pos = food.global_position
	
	var walk_to = root.get_meta( NameList.walk_to_target)
	walk_to.call(food_pos)
	var face_to = root.get_meta(NameList.turn_head_toward)
	face_to.call(food_pos)
	
	var get_target = root.get_meta(NameList.get_target)
	var target = get_target.call()
	if target == null:
		return false
	if target.is_in_group(NameList.food):
		return true
	return false

func get_food(root:Node3D,local_state:Dictionary):
	if local_state.has(NameList.food):
		var food = local_state[NameList.food]
		if food != null:
			return local_state[NameList.food]
		else:
			local_state.erase(NameList.food)
	var root_pos =root.global_position
	return WorldState.get_closest_node_3d(NameList.food, root_pos)
