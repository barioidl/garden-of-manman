extends Node
class_name Stats

@onready var root = get_parent().root

func _init() -> void:
	name = 'stats'

func _ready() -> void:
	owner = root
#	root.add_to_group('stats')
	root.connect('body_entered',body_entered)
	set_interface()
	connect_goap_agent()

func set_interface():
	root.set_meta('change_health', Callable(change_health))

func body_entered(body):
	fall_damage(body)


@export_category('health')
@export var use_health:=true
@export var health := 10.0
@export var max_health := 10.0
signal health_updated(hp,maxhp)

@export_category('mana')
@export var mana:=0.0
@export var max_mana:=10.0
signal mana_updated(hp,maxhp)

@export_category('hunger')
@export var hunger:=0.0
@export var max_hunger:=10.0
signal hunger_updated(hp,maxhp)

func change_health(delta):
	if delta == 0:return
	health = clampf(health+delta, 0, max_health)
	emit_signal(NameList.health_updated,health,max_health)
	
	hurt_sfx(delta)
	if health <= 0:
		die()

func change_mana(delta):
	if delta == 0:return
	mana = clampf(mana+delta, 0, max_mana)
	emit_signal(NameList.mana_updated,mana,max_mana)

func change_hunger(delta):
	if delta == 0:return
	hunger = clampf(hunger+delta, 0, max_hunger)
	emit_signal(NameList.hunger_updated,hunger,max_hunger)

func die():
	$"../inputs".reset()


var agent
func connect_goap_agent():
	agent = get_node_or_null("../goap_agent")
	if agent == null: return
	update_agent_hp(health,max_health)
	connect(NameList.health_updated,update_agent_hp)
#	connect(NameList.health_updated,update_agent_hp)
#	connect(NameList.health_updated,update_agent_hp)

func update_agent_hp(_health,_max_health):
	agent.set_local_state(NameList.health,_health)
	agent.set_local_state(NameList.max_health,_max_health)

func update_agent_mp(_mana,_max_mana):
	agent.set_local_state(NameList.mana,_mana)
	agent.set_local_state(NameList.max_mana,_max_mana)

func update_agent_hunger(_hunger,_max_hunger):
	agent.set_local_state(NameList.hunger,_hunger)
	agent.set_local_state(NameList.max_hunger,_max_hunger)



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
