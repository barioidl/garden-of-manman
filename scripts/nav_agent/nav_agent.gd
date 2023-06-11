extends Node3D
class_name NavAgent

@onready var nav_agent = $NavigationAgent3D
@onready var cast_floor = $"cast floor"

var character:Node3D
var target:Node3D
var target_pos:=Vector3.ZERO

var agent_radius:=1.0
var agent_height:=1.0

func _ready() -> void:
	pass

var dt := 0.0
func _physics_process(delta: float) -> void:
	dt = delta
	if character == null: return
	if !character.can_process(): 
		return
	global_position = character.to_global(Vector3(0,0.5,0))
	next_pos = nav_agent.get_next_path_position()
	update_target()
	offset_height()


func attach_to(_character:Node3D, _target):
	if _character == null: return
	
	character = _character
	cast_floor.add_exception(character)
	global_position = character.global_position
	
	var callable = Callable(get_nav_agent)
	character.set_meta(NL.get_nav_agent, callable)
	
#	set_agent_size(Vector2(0.25,1))
	set_target(_target)

func detach():
	if character == null: return
	
	character.remove_meta(NL.get_nav_agent)
	cast_floor.remove_exception(character)
	
	NavAgentPool.push_agent_3d(self)
	
	var input = Interface.get_input(character)
	if input != null:
		input.dpad1 = Vector2.ZERO
		input.dpad2 = Vector2.ZERO
	
	character = null
	target = null
	target_pos = Vector3.ZERO

var next_pos := Vector3.ZERO
func get_next_path_pos()->Vector3:
	return next_pos

func get_final_pos()-> Vector3:
	return nav_agent.get_final_position()

var update_target_cd := 0.0
func update_target():
	if target == null: return
	if update_target_cd > 0: 
		update_target_cd -=dt
		return
	update_target_cd = 0.5
	if target_pos == target.global_position:
		update_target_cd *= 2
	target_pos = target.global_position
	nav_agent.target_position = target_pos

var height_offset_cd:=1.0
func offset_height():
	height_offset_cd -= dt
	if height_offset_cd >0:return
	height_offset_cd = randf_range(0.5,1.0)
	
	cast_floor.force_raycast_update()
	if !cast_floor.is_colliding():
		nav_agent.agent_height_offset *= 0.99
		return
	var floor_point = cast_floor.get_collision_point()
	var floor_dist = global_position.distance_to(floor_point)
	nav_agent.agent_height_offset = -floor_dist

func set_target(_target):
	if _target == null: return
	if _target is Vector3:
		if target_pos == _target: return
		target_pos = _target
		nav_agent.target_position = target_pos
		return
	if  _target is Node3D:
		if _target == target: return
		target = _target
		target_pos = target.global_position
		nav_agent.target_position = target_pos
		return


func get_nav_agent()->Node3D:
	return self

func set_agent_size(_size:Vector2):
	agent_radius = _size.x
	agent_height = _size.y
	nav_agent.path_desired_distance = agent_radius
	nav_agent.target_desired_distance = agent_radius

func _target_reached() -> void:
	pass
