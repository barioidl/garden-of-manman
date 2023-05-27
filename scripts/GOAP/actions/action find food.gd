extends GOAPAction
class_name ActionFindFood

var range:=50.0

func _name()->StringName:
	return 'A find food'

func is_valid(local_state:Dictionary)->bool:
	var root = local_state.root
	var agent = local_state.agent
	var id = get_hotbar_food(root)
	if id >= 0:
		return false
	var food = agent.get_closest_node3d(NL.food,range)
	return food != null

func get_cost(local_state:Dictionary)->float:
	var root = local_state.root
	var agent = local_state.agent
	var food = agent.get_closest_node3d(NL.food,range)
	if food == null:
		return 1
	var dist = food.global_position - root.global_position
	dist = dist.length_squared() / (range*range)
	return dist * get_weight(NL.food)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_food:1,
	}

func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var agent = local_state.agent
	var food = agent.get_closest_node3d(NL.food,range)
	if food == null:
		return false
	
	if !reached_food(root):
		Interface.attach_nav_agent(root,food)
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	
	var input = Interface.get_input(root)
	if Interface.is_hotbar_full(root):
		input.emit_signal(NL.drop_pressed)
		return false
	input.emit_signal(NL.act_pressed)
	
	if local_state.has(NL.food):
		local_state.erase(NL.food)
	return true

func get_hotbar_food(root) -> int:
	var get_items = root.get_meta(NL.get_hotbar_items)
	var hotbar_items :Array= get_items.call()
	for id in hotbar_items.size():
		var food = hotbar_items[id]
		if food == null:
			continue
		if !food.is_in_group(NL.food):
			continue
		return id
	return -1

func reached_food(root)->bool:
	var target = Interface.get_target(root)
	if target == null:
		return false
	if !target.is_in_group(NL.food):
		return false
	return true
