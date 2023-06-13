extends GOAPAction
class_name ActionAttackPrey

func _name()->StringName:
	return &'A attack prey'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.preys)

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.prey_health: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var pos :Vector3= root.global_position
	var preys = local_state[NL.preys]
	var prey = ProximityTool.get_closest_node3d(preys, pos)
	if prey == null:
		_print('no prey to attack')
		return true
	
	var dist = pos.distance_squared_to(prey.global_position)
	var _range = local_state[NL.interact_range]
	if dist >= _range*_range:
		var agent := Interface.attach_nav_agent(root,prey)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,prey.global_position)
		_print('walking toward prey')
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('prey reached')
	
	var damage := randi_range(3, 6)
	Interface.change_health(prey, -damage)
	return true
