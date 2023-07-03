extends GOAPAction
class_name ActionFindFood

var _range := 10.0

func _name()->StringName:
	return &'A find food'

func is_valid(local_state:Dictionary)->bool:
	var root = local_state.root
	if cache_valid.has(root):
		return cache_valid[root]
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	var valid = food != null
	cache_valid[root] = valid
	return valid

func get_cost(local_state:Dictionary)->float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
	
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	if food == null: return 1
	var dist :Vector3= food.global_position - root.global_position
	var cost = dist.length_squared() / (_range*_range)
	cost *= get_weight(0)
	
	cache_cost[root] = cost
	return cost

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_food:1,
	}

func start(local_state:Dictionary):
	var root = local_state[NL.root]
	var items = Interface.get_hotbar_items(root)
	var item_size = items.size()
	if item_size <=0: 
		return
	var id = randi_range(0,item_size)
	if items[id] == null:return
	Interface.drop_item(root,id)
	_print('dropped item')

func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	if food == null:	return false
	
	var food_pos = food.global_position
	var dist = pos.distance_squared_to(food_pos)
	var _range = local_state[NL.interact_range]
	if dist >= _range*_range:
		var agent := Interface.attach_nav_agent(root,food)
		var next_pos = agent.get_next_path_pos()
		
		var final_pos = agent.get_final_pos()
		if final_pos.distance_squared_to(food_pos) > 0.5:
			cache_cost[root] = 0
			return true
		
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,food.global_position)
		_print('walking toward food')
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('food reached')
	
	Interface.interact_with(root,food,root)
	return true


func _print(line):
	return
	print(line)
