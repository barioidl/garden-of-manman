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
	if food == null:
		return false
	
	var walk_to = root.get_meta(NameList.walk_to_target)
	var face_to = root.get_meta(NameList.turn_head_toward)
	var food_pos = food.global_position
	walk_to.call(food_pos)
	face_to.call(food_pos)
	
	var target = root.get_meta(NameList.get_target).call()
	if target == null:
		return false
	if !target.is_in_group(NameList.food):
		return false
	
	var input = root.get_meta(NameList.get_inputs).call()
	
	var hotbar_full = root.get_meta(NameList.is_hotbar_full).call()
	if hotbar_full:
		input.emit_signal(NameList.drop_pressed)
		return false
	input.emit_signal(NameList.act_pressed)
	input.dpad1 = Vector2.ZERO
	input.dpad2 = Vector2.ZERO
	return true


func get_food(root:Node3D,local_state:Dictionary):
	if local_state.has(NameList.food):
		var food = local_state[NameList.food]
		if food == null:
			local_state.erase(NameList.food)
		else:
			return local_state[NameList.food]
	var root_pos =root.global_position
	return WorldState.get_closest_node_3d(NameList.food, root_pos)
