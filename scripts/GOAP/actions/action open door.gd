extends GOAPAction
class_name ActionOpenDoor

func _name()->StringName:
	return &'A open door'

func is_valid(local_state:Dictionary)->bool:
	var root :Node3D= local_state.root
	if cache_valid.has(root):
		return cache_valid[root]
	
	var keys := get_hotbar_keys(root)
	var _valid = !keys.is_empty()
	
	cache_valid[root] = _valid
	return _valid

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
#		NL.has_key:1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.door_close: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	
	var keys := get_hotbar_keys(root)
	var closed_lock = ProximityTool.get_closest_node3d(NL.locks, pos, 1, is_lock_open.bind(keys))
	if closed_lock == null:
		return true
	var dist = closed_lock.global_position.distance_squared_to(pos)
	if dist >= 4:
		var agent = Interface.attach_nav_agent(root,closed_lock)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,closed_lock.global_position)
		_print('walking to target')
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	
	for key in keys:
		Interface.interact_with(root,closed_lock,key)
	return true

func get_hotbar_keys(root)->Array:
	var hotbar_items := Interface.get_hotbar_items(root)
	if hotbar_items.is_empty(): return []
	var result := []
	for key in hotbar_items:
		if key == null:	continue
		if !key.is_in_group(NL.keys):	continue
		result.append(key)
	return result


func is_lock_open(lock:Node,keys:Array)->bool:
	var password_matched := false
	for key in keys:
		if key.password != lock.password:	continue
		password_matched = true
	if !password_matched:
		return false
	return !lock.open


func _print(line):
	return
	print(line)
