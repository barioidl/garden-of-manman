extends Node
class_name Stats

@onready var root = get_parent().root
var agent

@export_category('stats toggle')
@export var has_health:= true
@export var has_strength:= true
@export var has_mana:= true
@export var has_stamina:= true#basically oxygen
@export var has_thirst:= true
@export var has_hunger:= true


@export var health := Vector2(10,10)
signal health_updated(value,max)
signal die()

@export var strength:=Vector2(0,10)
signal strength_updated(value,max)

@export var mana:=Vector2(0,10)
signal mana_updated(value,max)

@export var stamina:=Vector2(0,10)
signal stamina_updated(value,max)

@export var thirst:=Vector2(0,10)
signal thirst_updated(value,max)

@export var hunger:=Vector2(0,10)
signal hunger_updated(value,max)


func _init() -> void:
	name = 'stats'
func _ready() -> void:
	owner = root
#	root.add_to_group('stats')
#	set_interface()
#	connect_goap_agent()


func change_health(delta):
	if delta == 0:return
	health.x = clampf(health.x + delta, 0, health.y)
	emit_signal(NL.health_updated, health.x, health.y)
	hurt_sfx(delta)
	if health.x <= 0:
		emit_signal('die')

func change_strength(delta):
	if delta == 0:return
	strength.x = clampf(strength.x + delta, 0, strength.y)
	emit_signal(NL.strength_updated, strength.x, strength.y)

func change_mana(delta):
	if delta == 0:return
	mana.x = clampf(mana.x + delta, 0, mana.y)
	emit_signal(NL.mana_updated, mana.x, mana.y)

func change_stamina(delta):
	if delta == 0:return
	stamina.x = clampf(stamina.x + delta, 0, stamina.y)
	emit_signal(NL.stamina_updated, stamina.x, stamina.y)

func change_thirst(delta):
	if delta == 0:return
	thirst.x = clampf(thirst.x + delta, 0, thirst.y)
	emit_signal(NL.thirst_updated, thirst.x, thirst.y)

func change_hunger(delta):
	if delta == 0:return
	hunger.x = clampf(hunger.x + delta, 0, hunger.y)
	emit_signal(NL.hunger_updated, hunger.x, hunger.y)


func set_interface():
	if has_health:
		root.set_meta(NL.change_health, Callable(change_health))
	if has_strength:
		root.set_meta(NL.change_strength, Callable(change_strength))
	if has_mana:
		root.set_meta(NL.change_mana, Callable(change_mana))
	
	if has_stamina:
		root.set_meta(NL.change_stamina, Callable(change_stamina))
	if has_thirst:
		root.set_meta(NL.change_thirst, Callable(change_thirst))
	if has_hunger:
		root.set_meta(NL.change_hunger, Callable(change_hunger))

func connect_goap_agent():
	agent = get_node_or_null("../goap_agent")
	if agent == null: return
	if has_health:
		update_agent_health(health.x,health.y)
		connect(NL.health_updated,update_agent_health)
	if has_mana:
		update_agent_mana(mana.x,mana.y)
		connect(NL.mana_updated,update_agent_mana)
	if has_stamina:
		update_agent_stamina(stamina.x,stamina.y)
		connect(NL.stamina_updated,update_agent_stamina)	
	if has_hunger:
		update_agent_hunger(hunger.x,hunger.y)
		connect(NL.hunger_updated,update_agent_hunger)

func update_agent_health(_value,_max):
	agent.set_local_state(NL.health,_value)
	agent.set_local_state(NL.max_health,_max)

func update_agent_strength(_value,_max):
	agent.set_local_state(NL.strength,_value)
	agent.set_local_state(NL.max_strength,_max)

func update_agent_mana(_value,_max):
	agent.set_local_state(NL.mana,_value)
	agent.set_local_state(NL.max_mana,_max)

func update_agent_stamina(_value,_max):
	agent.set_local_state(NL.stamina,_value)
	agent.set_local_state(NL.max_stamina,_max)

func update_agent_thirst(_value,_max):
	agent.set_local_state(NL.thirst,_value)
	agent.set_local_state(NL.max_thirst,_max)

func update_agent_hunger(_value,_max):
	agent.set_local_state(NL.hunger,_value)
	agent.set_local_state(NL.max_hunger,_max)



@export_category('sfx')
@export var hurt_sounds:AudioList
func hurt_sfx(delta:float):
	if delta >0: return
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,hurt_sounds)
