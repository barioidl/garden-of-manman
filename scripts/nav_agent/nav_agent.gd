extends Node3D

@onready var nav_agent = $NavigationAgent3D

@onready var cast_floor = $"cast floor"

var character:Node3D
var target:Node3D
var target_pos:=Vector3.ZERO
var target_reached :=false

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
	update_target()
	offset_height()
	
	var pos = get_next_pos()
	if target_reached:
		Interface.turn_head(character,target_pos)
	else:
		Interface.walk_to(character,pos)
		Interface.turn_head(character,pos)
	
	if character == null: return
	var mid_pos = Vector3(0,agent_height * 0.5,0)
	global_position = character.to_global(mid_pos)


func get_next_pos()->Vector3:
	return nav_agent.get_next_path_position()
	nav_agent.target_position

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
	height_offset_cd = 0.5
	
	cast_floor.force_raycast_update()
	if !cast_floor.is_colliding():
		nav_agent.agent_height_offset = 0
		return
	var floor_point = cast_floor.get_collision_point()
	var floor_dist = global_position.distance_to(floor_point)
	nav_agent.agent_height_offset = -floor_dist


func attach_to(_character:Node3D, _target, size:=Vector2.ONE):
	if _character == null: return
	character = _character
	cast_floor.add_exception(character)
	global_position = character.global_position
	target_reached = false
	var callable = Callable(get_nav_agent)
	character.set_meta(NL.get_nav_agent, callable)
	
	set_agent_size(size)
	set_target(_target)

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

func get_nav_agent()->Node3D:
	return self

func set_agent_size(_size:Vector2):
	agent_radius = _size.x
	agent_height = _size.y
	nav_agent.path_desired_distance = agent_radius
	nav_agent.target_desired_distance = agent_radius

func _target_reached() -> void:
	target_reached = true
