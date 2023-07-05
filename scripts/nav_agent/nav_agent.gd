extends Node
class_name NavAgent

var character:Node3D
var target:Node3D
var target_pos:=Vector3.ZERO

var path_data:PathData
var path_id := 0

func _ready() -> void:
	pass

var dt := 0.0
func _process(delta: float) -> void:
	dt = delta
	if character == null: return
	if !character.can_process(): 
		detach()
		return
#	global_position = character.to_global(Vector3(0,0.5,0))
#	next_pos = nav_agent.get_next_path_position()
	update_target()


func attach_to(_character:Node3D, _target):
	if _character == null: return
	character = _character
	
	var callable = Callable(get_nav_agent)
	character.set_meta(NL.get_nav_agent, callable)
	set_target(_target)

func detach():
	if character == null: return
	character.remove_meta(NL.get_nav_agent)
	
	NavigationTool.push_agent_3d(self)
	
	var input = Interface.get_input(character)
	if input != null:
		input.dpad1 = Vector2.ZERO
		input.dpad2 = Vector2.ZERO
	
	character = null
	target = null
	target_pos = Vector3.ZERO

var next_pos := Vector3.ZERO
func get_next_path_pos()->Vector3:
	var dist = character.global_position.distance_squared_to(next_pos)
	if dist > 0.5:
		return next_pos
	if path_id >= path_data.path.size():
		return next_pos
	path_id += 1
	next_pos = path_data.path[path_id]
	return next_pos

#func get_final_pos()-> Vector3:
#	return Vector3.ZERO

var update_target_cd := 0.0
func update_target():
	if target == null: return
	if update_target_cd > 0: 
		update_target_cd -=dt
		return
	update_target_cd = randf_range(0.4,1.0)
	if target_pos == target.global_position:
		update_target_cd *= 2
	target_pos = target.global_position
	request_path()

func set_target(_target):
	if _target == null: return
	if _target is Vector3:
		if target_pos == _target: return
		target = null
		target_pos = _target
		request_path()
		return
	if  _target is Node3D:
		if _target == target: return
		target = _target
		target_pos = target.global_position
		request_path()
		return

func request_path():
	var start_pos = character.global_position
	path_data = NavigationTool.find_path(start_pos,target_pos)
	path_id = 0
	if !path_data.path.is_empty():
		next_pos = path_data.path[path_id]


func get_nav_agent()->Node:
	return self

