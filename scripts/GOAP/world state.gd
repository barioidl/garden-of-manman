extends Node
#class_name WorldState

var dt :=0.0
func _process(delta: float) -> void:
	dt = delta
	cleanup_groups()

var states:={}
func get_state(key,default = 0):
	return states.get(key,default)
func set_state(key,value):
	states[key] = value
func reset_states():
	states = {}

func get_player_character()->Node3D:
	return PlayerInputs.character

var group_lifetime := {}
func cleanup_groups():
	var keys = group_lifetime.keys()
	for i in group_lifetime.size():
		var key = keys[i]
		var lifetime = group_lifetime[key]
		lifetime -= dt
		group_lifetime[key] = lifetime
		if lifetime > 0:
			continue
		group_lifetime.erase(key)
		saved_groups.erase(key)

var saved_groups := {}
func get_nodes(group:StringName)->Array:
	if saved_groups.has(group):
		return saved_groups[group]
	
	group_lifetime[group] = 1.0
	var nodes = get_tree().get_nodes_in_group(group)
	saved_groups[group] = nodes
	return nodes

func get_closest_node_3d(group:StringName, position:Vector3, max_distance:=100.0)->Node3D:
	var nodes := get_nodes(group)
	var closest_node:Node3D=null
	var min_distance_sq := max_distance*max_distance
	for node in nodes:
		if node == null:
			continue
		var pos = node.global_position
		var dist_sq = position.distance_squared_to(pos)
		if dist_sq < min_distance_sq:
			min_distance_sq = dist_sq
			closest_node = node
	return closest_node
