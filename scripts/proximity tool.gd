extends Node

@onready var scene_tree := get_tree()

var def_range := 20.0
var def_lifetime := 0.5

func _print(line:String):
	return
	print(line)

var cd := 0.0
func _process(delta: float) -> void:
	if cd >0:
		cd -= delta
		return
	cd = 0.2
	cleanup_groups(0.2)
	cleanup_closest(0.2)
	cleanup_farest(0.2)

#func set_interface():
#	set_meta(NL.get_closest_node3d,get_closest_node3d)
#	set_meta(NL.get_farest_node3d,get_farest_node3d)
#	set_meta(NL.get_random_position,get_random_position)


func get_random_position(center:Vector3, min_range:=Vector3.ONE, max_range:=Vector3.ONE):
	var range := max_range
	if min_range.x != max_range.x:
		range.x = randf_range(min_range.x, max_range.x)
	if min_range.y != max_range.y:
		range.y = randf_range(min_range.y, max_range.y)
	if min_range.z != max_range.z:
		range.z = randf_range(min_range.z, max_range.z)
	closest_buffer.size()
	if randi()%20 < 10: range.x *= -1
	if randi()%20 < 10: range.y *= -1
	if randi()%20 < 10: range.z *= -1
	return center + range


func get_closest_node3d(groups, pos:Vector3, _range:=1.0, custom_conds:=def_conds)-> Node3D:
	_range = _range * def_range
	if groups is String or groups is StringName:
		return nearest_node3d_in_group(groups, pos, _range, custom_conds)
	if groups is Array:
		return nearest_node3d_in_groups(groups, pos, _range, custom_conds)
	return null


func get_farest_node3d(groups, pos:Vector3, _range:=1.0, custom_conds:=def_conds)-> Node3D:
	_range = _range * def_range
	if groups is String or groups is StringName:
		return farest_node3d_in_group(groups, pos, _range, custom_conds)
	if groups is Array:
		return farest_node3d_in_groups(groups, pos, _range, custom_conds)
	return null


func nearest_node3d_in_groups(groups:Array, pos:Vector3, _range:float, custom_conds:Callable)-> Node3D:
	var groups_size:= groups.size()
	if groups_size <= 0:
		return null
	if groups_size == 1:
		return nearest_node3d_in_group(groups[0], pos, _range, custom_conds)
	
	var groups_name := str(pos.floor())
	for group in groups:
		groups_name += group
	
	if closest_buffer.has(groups_name):
		var node = closest_buffer[groups_name]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	
	var closest_node:Node3D
	var nearest_distance:= _range * _range
	for group in groups:
		var node = closest_node3d(group, pos, _range, custom_conds)
		if node == null:
			continue
		if !custom_conds.call(node):
			continue
		var dist = pos.distance_squared_to(node.global_position)
		if dist >= nearest_distance:
			continue
		nearest_distance = dist
		closest_node = node
	_print('use new closest 3d node')
	closest_buffer[groups_name] = closest_node
	closest_lifetime[groups_name] = def_lifetime
	return closest_node

func farest_node3d_in_groups(groups:Array, pos:Vector3, _range:float, custom_conds:Callable)-> Node3D:
	var groups_size:= groups.size()
	if groups_size <= 0:
		return null
	if groups_size == 1:
		return farest_node3d_in_group(groups[0], pos, _range, custom_conds)
	
	var groups_name := str(pos.floor())
	for group in groups:
		groups_name += group
	
	if farest_buffer.has(groups_name):
		var node = farest_buffer[groups_name]
		if node != null:
			_print('use existing farest 3d node')
			return node 
	
	var farest_node:Node3D
	var farest_distance:= _range * _range
	for group in groups:
		var node = closest_node3d(group, pos, _range, custom_conds)
		if node == null:
			continue
		if !custom_conds.call(node):
			continue
		var dist = pos.distance_squared_to(node.global_position)
		if dist >= farest_distance:
			continue
		farest_distance = dist
		farest_node = node
	_print('use new farest 3d node')
	farest_buffer[groups_name] = farest_node
	farest_lifetime[groups_name] = def_lifetime
	return farest_node


func nearest_node3d_in_group(group:String, pos:Vector3, _range:float,custom_conds:Callable)-> Node3D:
	var group_name := str(pos.floor()) + group
	if closest_buffer.has(group_name):
		var node = closest_buffer[group_name]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	_print('use new closest 3d node')
	var node = closest_node3d(group, pos, _range, custom_conds)
	closest_buffer[group_name] = node
	closest_lifetime[group_name] = def_lifetime
	return node

func farest_node3d_in_group(group:String, pos:Vector3, _range:float, custom_conds:Callable)-> Node3D:
	var group_name := str(pos.floor()) + group
	if farest_buffer.has(group_name):
		var node = farest_buffer[group_name]
		if node != null:
			_print('use existing farest 3d node')
			return node
	_print('use new farest 3d node')
	var node = farest_node3d(group, pos, _range, custom_conds)
	farest_buffer[group_name] = node
	farest_lifetime[group_name] = def_lifetime
	return node


func closest_node3d(group:StringName, position:Vector3, max_distance:float, custom_conds:Callable)->Node3D:
	var nodes := get_nodes(group)
	var closest_node :Node3D= null
	var min_distance_sq := max_distance * max_distance
	for node in nodes:
		if node == null:
			continue
		if !custom_conds.call(node):
			continue
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq >= min_distance_sq:
			continue
		min_distance_sq = dist_sq
		closest_node = node
	return closest_node

func farest_node3d(group:StringName, position:Vector3, max_distance:float, custom_conds:Callable)->Node3D:
	var nodes := get_nodes(group)
	var farest_node :Node3D= null
	max_distance *= max_distance
	var max_dist := 0.0
	for node in nodes:
		if node == null:
			continue
		if !custom_conds.call(node):
			continue
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq >= max_distance:
			continue
		if dist_sq <= max_dist:
			continue
		max_dist = dist_sq
		farest_node = node
	return farest_node

func def_conds(node:Node3D)->bool:
	return true

func get_nodes(group:StringName)->Array:
	if groups_buffer.has(group):
		var result :Array= groups_buffer[group]
		if !result.is_empty():
			return result
	var nodes = scene_tree.get_nodes_in_group(group)
	groups_buffer[group] = nodes
	groups_lifetime[group] = def_lifetime
	return nodes


var groups_buffer := {}
var groups_lifetime := {}
func cleanup_groups(delta):
	var iterations = groups_lifetime.size()
	if iterations <=0: return
	var keys = groups_lifetime.keys()
	for i in iterations:
		var key = keys[i]
		groups_lifetime[key] -= delta
		if groups_lifetime[key] > 0: continue
		groups_lifetime.erase(key)
		groups_buffer.erase(key)

var closest_buffer := {}
var closest_lifetime := {}
func cleanup_closest(delta):
	var iterations = closest_lifetime.size()
	if iterations <=0: return
	var keys = closest_lifetime.keys()
	for i in iterations:
		var key = keys[i]
		closest_lifetime[key] -= delta
		if closest_lifetime[key] > 0: continue
		closest_lifetime.erase(key)
		closest_buffer.erase(key)

var farest_buffer := {}
var farest_lifetime := {}
func cleanup_farest(delta):
	var iterations = farest_lifetime.size()
	if iterations <=0: return
	var keys = farest_lifetime.keys()
	for i in iterations:
		var key = keys[i]
		farest_lifetime[key] -= delta
		if farest_lifetime[key] > 0: continue
		farest_lifetime.erase(key)
		farest_buffer.erase(key)
