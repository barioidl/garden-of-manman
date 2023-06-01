extends Node
class_name ProximityTool

var root:Node3D
var agent:GOAPAgent
@export var def_range:=100.0

func _init() -> void:
	name = NL.proximity_tool

func _enter_tree() -> void:
	root = get_parent().root
	owner = root
	set_interface()
func _ready() -> void:
	agent = Interface.get_goap_agent(root)
	agent.set_local_state(NL.proximity_tool,self)

func set_interface():
	root.set_meta(NL.get_closest_node3d,get_closest_node3d)
	root.set_meta(NL.get_farest_node3d,get_farest_node3d)
	root.set_meta(NL.get_random_position,get_random_position)



func get_random_position(center:Vector3, min_range:=Vector3.ONE, max_range:=Vector3.ONE):
	var range := max_range
	if min_range.x != max_range.x:
		range.x = randf_range(min_range.x, max_range.x)
	if min_range.y != max_range.y:
		range.y = randf_range(min_range.y, max_range.y)
	if min_range.z != max_range.z:
		range.z = randf_range(min_range.z, max_range.z)
	
	if randi()%20 <10:range.x *= -1
	if randi()%20 <10:range.y *= -1
	if randi()%20 <10:range.z *= -1
	
	return center + range

var closest_buffer := {}
func get_closest_node3d(groups, pos :Vector3, _range:=def_range)-> Node3D:
	if groups is String or groups is StringName:
		return nearest_node3d_in_group(groups,pos,_range)
	if groups is Array:
		return nearest_node3d_in_groups(groups,pos,_range)
	return null

func nearest_node3d_in_groups(groups:Array, pos:Vector3, _range:float)-> Node3D:
	var groups_size:= groups.size()
	if groups_size <= 0:
		return null
	if groups_size ==1:
		return nearest_node3d_in_group(groups[0],pos,_range)
	
	var groups_name :=''
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
		var node = WorldState.get_closest_node3d(group, pos, _range)
		if node == null:
			continue
		var dist = pos.distance_squared_to(node.global_position)
		if dist >= nearest_distance:
			continue
		nearest_distance = dist
		closest_node = node
	
	_print('use new closest 3d node')
	closest_buffer[groups_name] = closest_node
	return closest_node

func nearest_node3d_in_group(group:String, pos:Vector3, _range:float)-> Node3D:
	if closest_buffer.has(group):
		var node = closest_buffer[group]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	var node = WorldState.get_closest_node3d(group, pos, _range)
	closest_buffer[group] = node
	_print('use new closest 3d node')
	return node



var farest_buffer := {}
func get_farest_node3d(groups, pos:Vector3, _range:=def_range)-> Node3D:
	if groups is String or groups is StringName:
		return farest_node3d_in_group(groups,pos,_range)
	if groups is Array:
		return farest_node3d_in_groups(groups,pos,_range)
	return null

func farest_node3d_in_groups(groups:Array, pos:Vector3, _range:float)-> Node3D:
	var groups_size:= groups.size()
	if groups_size <= 0:
		return null
	if groups_size ==1:
		return farest_node3d_in_group(groups[0],pos,_range)
	
	var groups_name :=''
	for group in groups:
		groups_name += group
	
	if farest_buffer.has(groups_name):
		var node = farest_buffer[groups_name]
		if node != null:
			_print('use existing closest 3d node')
			return node 
	
	var farest_node:Node3D
	var farest_distance:= _range * _range
	for group in groups:
		var node = WorldState.get_closest_node3d(group, pos, _range)
		if node == null:
			continue
		var dist = pos.distance_squared_to(node.global_position)
		if dist >= farest_distance:
			continue
		farest_distance = dist
		farest_node = node
	
	_print('use new closest 3d node')
	farest_buffer[groups_name] = farest_node
	return farest_node

func farest_node3d_in_group(group:String, pos:Vector3, _range:float)-> Node3D:
	if farest_buffer.has(group):
		var node = farest_buffer[group]
		if node != null:
			_print('use existing farthest 3d node')
			return node
	var node = WorldState.get_farest_node3d(group, pos, _range)
	farest_buffer[group] = node
	_print('use new farthest 3d node')
	return node


func _print(line:String):
	return
	print(line)
