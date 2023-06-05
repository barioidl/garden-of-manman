extends Node
#class_name WorldState

var dt :=0.0
func _process(delta: float) -> void:
	dt = delta
	cleanup_groups()


var states:={}
func get_(key,default = 0):
	return states.get(key,default)
func set_(key,value):
	states[key] = value
func remove_(key):
	states.erase(key)
func reset_():
	states = {}


var groups_lifetime := {}
func cleanup_groups():
	var keys = groups_lifetime.keys()
	for i in groups_lifetime.size():
		var key = keys[i]
		var lifetime = groups_lifetime[key]
		lifetime -= dt
		groups_lifetime[key] = lifetime
		if lifetime > 0: continue
		groups_lifetime.erase(key)
		groups_buffer.erase(key)


var groups_buffer := {}
func get_nodes(group:StringName)->Array:
	if groups_buffer.has(group):
		return groups_buffer[group]
	
	groups_lifetime[group] = 1.0
	var nodes = get_tree().get_nodes_in_group(group)
	groups_buffer[group] = nodes
	return nodes

func get_closest_node3d(group:StringName, position:Vector3, max_distance:=100.0)->Node3D:
	var nodes := get_nodes(group)
	var closest_node :Node3D= null
	var min_distance_sq := max_distance * max_distance
	for node in nodes:
		if node == null:
			continue
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq >= min_distance_sq:
			continue
		min_distance_sq = dist_sq
		closest_node = node
	return closest_node

func get_farest_node3d(group:StringName, position:Vector3, max_distance:=100.0)->Node3D:
	var nodes := get_nodes(group)
	var farest_node :Node3D= null
	max_distance *= max_distance
	var max_dist := 0.0
	for node in nodes:
		if node == null:
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
