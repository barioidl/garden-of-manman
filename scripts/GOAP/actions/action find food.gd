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
		NL.has_food:1,
	}


func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var food = get_food(root,local_state)
	if food == null:
		return false
	var food_pos = food.global_position
	
	if !reached_food(root):
		Interface.walk_to(root,food_pos)
		Interface.turn_head(root,food_pos)
		return false
	
	var input = Interface.get_input(root)
	if Interface.is_hotbar_full(root):
		input.emit_signal(NL.drop_pressed)
	input.emit_signal(NL.act_pressed)
	input.dpad1 = Vector2.ZERO
	input.dpad2 = Vector2.ZERO
	
	if local_state.has(NL.food):
		local_state.erase(NL.food)
	return true

func reached_food(root)->bool:
	var target = Interface.get_target(root)
	if target == null:
		return false
	if !target.is_in_group(NL.food):
		return false
	return true

func get_food(root:Node3D,local_state:Dictionary):
	if local_state.has(NL.food):
		var food = local_state[NL.food]
		if food == null:
			local_state.erase(NL.food)
		else:
			return local_state[NL.food]
	var root_pos =root.global_position
	var food = WorldState.get_closest_node_3d(NL.food, root_pos)
	local_state[NL.food] = food
	return food
