extends GOAPAction
class_name ActionFindFood

var range:=50.0

func name()->StringName:
	return 'A find food'

func is_valid(local_state:Dictionary)->bool:
	var root = local_state.root
	var food := get_food(root,local_state)
	return food != null

func get_cost(local_state:Dictionary)->float:
	var root = local_state.root
	var food := get_food(root,local_state)
	if food == null:
		return 1
	var dist = food.global_position - root.global_position
	dist = dist.length_squared()
	return dist / (range*range)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_food:1,
	}

func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var food = get_food(root,local_state)
	if food == null:
		return false
	
	if !reached_food(root):
		if root.has_meta(NL.get_nav_agent):
			return false
		var agent = NavAgentPool.get_agent_3d()
		agent.attach_to(root,food)
		return false
	
	if root.has_meta(NL.get_nav_agent):
		var agent = root.get_meta(NL.get_nav_agent).call()
		agent.detach()
	
	var input = Interface.get_input(root)
	if Interface.is_hotbar_full(root):
		input.emit_signal(NL.drop_pressed)
		return false
	input.emit_signal(NL.act_pressed)
	
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

func get_food(root:Node3D,local_state:Dictionary)-> Node3D:
	if local_state.has(NL.food):
		var food = local_state[NL.food]
		if food == null:
			local_state.erase(NL.food)
		else:
			return local_state[NL.food]
	var root_pos =root.global_position
	var food = WorldState.get_closest_node_3d(NL.food, root_pos, range)
	local_state[NL.food] = food
	return food
