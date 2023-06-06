extends GOAPAction
class_name ActionFindFood

var range:=50.0

func _name()->StringName:
	return &'A find food'

func is_valid(local_state:Dictionary)->bool:
	var root = local_state.root
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	var valid = food != null
	_print('food available: ' + str(valid))
	return valid

func get_cost(local_state:Dictionary)->float:
	var root = local_state.root
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	if food == null:
		return 1
	var dist :Vector3= food.global_position - root.global_position
	var cost = dist.length_squared() / (range*range)
	cost *= get_weight(0)
	_print('food cost ' + str(cost))
	return cost

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_food:1,
	}

func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	if food == null:
		return true
	
	if !Interface.interact_with(root,food):
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

func _print(line:String):
#	return
	print(line)
