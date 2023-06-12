extends GOAPAction
class_name ActionFindKey

func _name()->StringName:
	return &'A find key'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_key: 1
	}

func start(local_state:Dictionary):
	var root = local_state[NL.root]
	var items = Interface.get_hotbar_items(root)
	for id in items.size():
		var item = items[id]
		if item == null:	continue
		if item.is_in_group(NL.keys):	continue
		Interface.drop_item(root,id)
		break

func perform(local_state:Dictionary,time:float)-> bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var key = ProximityTool.get_closest_node3d(NL.keys, pos,1,key_check)
	if key == null:
		_print('no key?')
		return false
	var dist = key.global_position.distance_squared_to(pos)
	var _range = local_state[NL.interact_range]
	if dist >= _range*_range:
		var agent = Interface.attach_nav_agent(root,key)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,key.global_position,1,0.2)
		_print('walking toward key')
		return false
	Interface.interact_with(root,key,root)
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('key reached')
	return true

func key_check(key:Node)->bool:
	return key.is_in_overworld

func _print(line):
#	return
	print(line)
