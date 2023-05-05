extends Node
class_name Stats

@onready var root:RigidCharacter=$'..'.root

@export var max_health:=10.0
var health:=max_health

@export var has_fall_damage:=false
@export var fall_speed_range:=Vector2(10,50)
@export var fall_damage_range:=Vector2(1,10)

func _init() -> void:
	owner = root
	name = 'stats'

func _ready() -> void:
	root.add_to_group('stats')
	root.connect('body_entered',body_entered)
	root.set_meta('change_health',Callable(change_health))

signal health_updated(hp,maxhp)
func change_health(delta):
	if delta == 0:return
	health += delta
	health = clampf(health,0,max_health)
	emit_signal('health_updated',health,max_health)
	hurt_sfx(delta)

@export var hurt_sounds:AudioList
func hurt_sfx(delta:float):
	if delta >0: return
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,hurt_sounds)

func body_entered(body):
	fall_damage(body)

func fall_damage(body):
	if !has_fall_damage:return
	var velocity:=Vector3.ZERO
	if body is RigidBody3D:
		velocity = body.linear_velocity
	elif body is CharacterBody3D:
		velocity = body.velocity
	elif  body is StaticBody3D:
		velocity = body.constant_linear_velocity
	var velo_dist = root.linear_velocity.distance_squared_to(velocity)
	
	print(velo_dist)
