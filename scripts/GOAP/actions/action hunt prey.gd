extends GOAPAction
class_name ActionHuntPrey

func _name()->StringName:
	return &'A hunt prey'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.preys)

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.prey_tension: 1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var pos :Vector3= root.global_position
	var preys = local_state[NL.preys]
	var detect_ranges := bake_detections(local_state)
	var prey = ProximityTool.get_closest_node3d(preys, pos,1, can_spot_prey.bindv(detect_ranges))
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
	return true

func bake_detections(local_state:Dictionary)->Array:
	var sensors := [0,0,0]
	if local_state.has(NL.sight):
		sensors[0] = local_state[NL.sight]
	if local_state.has(NL.motion):
		sensors[1] = local_state[NL.motion]
	if local_state.has(NL.sound):
		sensors[2] = local_state[NL.sound]
	return sensors

func can_spot_prey(prey:Node, range:float,
 sight:float, motion:float, sound:float )->bool:
	if sight > 0:
		if range < sight * sight:
			return true
	if motion > 0:
		if range < motion * motion:
			if prey.linear_velocity != Vector3.ZERO:
				_print('prey moving')
				return true
	if sound > 0:
		if range < sound * sound:
			return true
	return false

func _print(line):
#	return
	print(line)
