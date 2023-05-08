extends Node
#class_name WorldState
var time :=0.0
func _process(delta: float) -> void:
	cleanup_groups()

var states:={}
func get_state(key,default = 0):
	return states.get(key,default)
func set_state(key,value):
	states[key] = value
func reset_states():
	states = {}

var saved_groups := {}
var delay_clean_groups := 0.0
func cleanup_groups():
	if delay_clean_groups <= -1: 
		return
	if delay_clean_groups >0:
		delay_clean_groups -= time
		return
	delay_clean_groups = -1
	saved_groups = {}

func get_nodes(group:StringName)->Array:
	if saved_groups.has(group):
		return saved_groups[group]
	
	delay_clean_groups = 0.1
	var nodes = get_tree().get_nodes_in_group(group)
	saved_groups[group] = nodes
	return nodes

func get_closest_node_3d(group:StringName, position:Vector3, max_distance:float)->Node3D:
	var nodes := get_nodes(group)
	var closest_node:Node3D
	var min_distance_sq := max_distance*max_distance
	for node in nodes:
		var dist_sq = position.distance_squared_to(node.position)
		if dist_sq < min_distance_sq:
			min_distance_sq = dist_sq
			closest_node = node
	return closest_node
