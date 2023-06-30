extends Node

@onready var scene_tree := get_tree()

var def_range := 30.0
var def_lifetime := 0.5
var resolution := Vector3.ONE * 5


func _print(line:String):
	return
	print(line)

var cd := 0.0
func _process(delta: float) -> void:
	if cd >0:
		cd -= delta
		return
	var duration = randf_range(0.8,1.2)
	cd = duration
	cleanup_groups(duration)
	cleanup_closest(duration)
	cleanup_farest(duration)

#func set_interface():
#	set_meta(NL.get_closest_node3d,get_closest_node3d)
#	set_meta(NL.get_farest_node3d,get_farest_node3d)
#	set_meta(NL.get_random_position,get_random_position)
#
#
#func get_random_position(center:Vector3, min_range:=Vector3.ONE, max_range:=Vector3.ONE):
#	var range := max_range
#	if min_range.x != max_range.x:
#		range.x = randf_range(min_range.x, max_range.x)
#	if min_range.y != max_range.y:
#		range.y = randf_range(min_range.y, max_range.y)
#	if min_range.z != max_range.z:
#		range.z = randf_range(min_range.z, max_range.z)
#	closest_cache.size()
#	if randi()%20 < 10: range.x *= -1
#	if randi()%20 < 10: range.y *= -1
#	if randi()%20 < 10: range.z *= -1
#	return center + range


func get_closest_node3d(groups, pos:Vector3, _range:=1.0, custom_conds:=def_conds)-> Node3D:
	_range = def_range
	if groups is String or groups is StringName:
		return nearest_node3d_in_group(groups, pos, _range, custom_conds)
	if groups is Array:
		return nearest_node3d_in_groups(groups, pos, _range, custom_conds)
	return null


func get_farest_node3d(groups, pos:Vector3, _range:=1.0, custom_conds:=def_conds)-> Node3D:
	_range = def_range
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
	
	var groups_name := str(snapped(pos,resolution))
	for group in groups:
		groups_name += group
	groups_name += custom_conds.get_method()
	
	if closest_cache.has(groups_name):
		var node = closest_cache[groups_name]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	
	var closest_node:Node3D
	var nearest_distance:= _range * _range
	for group in groups:
		var node = closest_node3d(group, pos, _range, custom_conds)
		if node == null:continue
		var dist_sq = pos.distance_squared_to(node.global_position)
		if dist_sq >= nearest_distance:continue
		if !custom_conds.call(node, dist_sq):continue
		nearest_distance = dist_sq
		closest_node = node
	_print('use new closest 3d node')
	closest_cache[groups_name] = closest_node
	return closest_node

func farest_node3d_in_groups(groups:Array, pos:Vector3, _range:float, custom_conds:Callable)-> Node3D:
	var groups_size:= groups.size()
	if groups_size <= 0:
		return null
	if groups_size == 1:
		return farest_node3d_in_group(groups[0], pos, _range, custom_conds)
	
	var groups_name := str(snapped(pos,resolution))
	for group in groups:
		groups_name += group
	groups_name += custom_conds.get_method()
	
	if farest_cache.has(groups_name):
		var node = farest_cache[groups_name]
		if node != null:
			_print('use existing farest 3d node')
			return node 
	
	var farest_node:Node3D
	var farest_distance:= _range * _range
	for group in groups:
		var node = closest_node3d(group, pos, _range, custom_conds)
		if node == null:continue
		var dist_sq = pos.distance_squared_to(node.global_position)
		if dist_sq <= farest_distance:continue
		if !custom_conds.call(node, dist_sq):continue
		farest_distance = dist_sq
		farest_node = node
	_print('use new farest 3d node')
	farest_cache[groups_name] = farest_node
	return farest_node


func nearest_node3d_in_group(group:String, pos:Vector3, _range:float,custom_conds:Callable)-> Node3D:
	var group_name := str(snapped(pos,resolution)) + group
	group_name += custom_conds.get_method()
	
	if closest_cache.has(group_name):
		var node = closest_cache[group_name]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	_print('use new closest 3d node')
	var node = closest_node3d(group, pos, _range, custom_conds)
	closest_cache[group_name] = node
	return node

func farest_node3d_in_group(group:String, pos:Vector3, _range:float, custom_conds:Callable)-> Node3D:
	var group_name := str(snapped(pos,resolution)) + group
	group_name += custom_conds.get_method()
	
	if farest_cache.has(group_name):
		var node = farest_cache[group_name]
		if node != null:
			_print('use existing farest 3d node')
			return node
	_print('use new farest 3d node')
	var node = farest_node3d(group, pos, _range, custom_conds)
	farest_cache[group_name] = node
	return node


func closest_node3d(group:StringName, position:Vector3, max_distance:float, custom_conds:Callable)->Node3D:
	var nodes := get_nodes(group)
	var closest_node :Node3D= null
	var min_distance_sq := max_distance * max_distance
	for node in nodes:
		if node == null:
			continue
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq >= min_distance_sq:continue
		if !custom_conds.call(node, dist_sq):continue
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
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq >= max_distance:continue
		if dist_sq <= max_dist:continue
		if !custom_conds.call(node, dist_sq):continue
		max_dist = dist_sq
		farest_node = node
	return farest_node


func get_nodes(group:StringName)->Array:
	if groups_cache.has(group):
		var result :Array= groups_cache[group]
		if !result.is_empty():
			return result
	var nodes = scene_tree.get_nodes_in_group(group)
	groups_cache[group] = nodes
	return nodes


var groups_cache := {}
func cleanup_groups(delta):
	groups_cache.clear()

var closest_cache := {}
func cleanup_closest(delta):
	closest_cache.clear()

var farest_cache := {}
func cleanup_farest(delta):
	farest_cache.clear()


func def_conds(node:Node3D,dist_sq:float)->bool:
	return true
