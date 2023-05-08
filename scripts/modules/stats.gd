extends Node
class_name Stats

@onready var root:RigidCharacter=$'..'.root

func _init() -> void:
	name = 'stats'

func _ready() -> void:
	owner = root
	root.add_to_group('stats')
	root.connect('body_entered',body_entered)
	root.set_meta('change_health',Callable(change_health))
	connect_goap_agent()

func body_entered(body):
	fall_damage(body)

var agent
func connect_goap_agent():
	agent = get_node_or_null("../goap_agent")
	if agent == null: return
	connect("health_updated",update_agent_hp)

func update_agent_hp(health,max_health):
	agent.set_local_state(Goap.keys.health,health)
	agent.set_local_state(Goap.keys.max_health,max_health)

@export_category('health')
@export var health := 10.0
@export var max_health := 10.0
signal health_updated(hp,maxhp)
func change_health(delta):
	if delta == 0:return
	health = clampf(health+delta, 0, max_health)
	emit_signal('health_updated',health,max_health)
	
	hurt_sfx(delta)
	if health <= 0:
		die()

func die():
	pass

@export_category('hunger')
@export var hunger:=0.0
@export var max_hunger:=10.0
signal hunger_updated(hp,maxhp)
func change_hunger(delta):
	if delta == 0:return
	hunger = clampf(hunger+delta, 0, max_hunger)
	emit_signal('hunger_updated',hunger,max_hunger)

@export_category('fall damage')
@export var has_fall_damage:=false
@export var fall_speed_offset:=10.0
@export var fall_speed_range:=10.0
@export var fall_max_damage:=10.0
func fall_damage(body):
	if !has_fall_damage:return
	var velocity:=Vector3.ZERO
	if body is RigidBody3D:
		velocity = body.linear_velocity
	elif body is CharacterBody3D:
		velocity = body.velocity
	elif  body is StaticBody3D:
		velocity = body.constant_linear_velocity
	var velo_dist = root.linear_velocity. distance_squared_to( velocity)
	
	print(velo_dist)


@export_category('sfx')
@export var hurt_sounds:AudioList
func hurt_sfx(delta:float):
	if delta >0: return
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,hurt_sounds)
