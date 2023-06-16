extends GOAPAction
class_name ActionChasePreySound

func _name()->StringName:
	return &'A chase prey sound'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.preys)

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.prey_distance: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var pos :Vector3= root.global_position
	
	var preys = local_state[NL.preys]
	var prey := ProximityTool.get_closest_node3d(preys, pos)
	if prey == null:
		_print('no prey to attack')
		return true
	var prey_pos := prey.global_position
	
	var audio := ProximityTool.get_closest_node3d(NL.audio_player_3d, pos)
	if audio == null:
		var input = Interface.get_input(root)
		if input != null:
			input.dpad1 = Vector2.ZERO
			input.dpad2 = Vector2.ZERO
		_print('no audio to follow')
		return false
	var audio_dist = audio.global_position.distance_squared_to(prey_pos)
	
	var interact_range = local_state[NL.interact_range]
	interact_range *= interact_range
	if audio_dist > interact_range:
		var input = Interface.get_input(root)
		if input != null:
			input.dpad1 = Vector2.ZERO
			input.dpad2 = Vector2.ZERO
		_print('audio out of range')
		return false
	
	var dist = pos.distance_squared_to(prey_pos)
	if dist >= interact_range:
		var agent := Interface.attach_nav_agent(root, audio)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root, next_pos)
		Interface.turn_head(root, prey_pos)
		_print('walking toward prey')
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('prey reached')
	return true

func _print(line):
	return
	print(line)
