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


@export_category('health')
@export var health := 10.0
@export var max_health := 10.0
signal health_updated(value,max)
signal die()

@export_category('strength')
@export var strength:=0.0
@export var max_strength:=10.0
signal strength_updated(value,max)

@export_category('mana')
@export var mana:=0.0
@export var max_mana:=10.0
signal mana_updated(value,max)

@export_category('stamina')
@export var stamina:=0.0
@export var max_stamina:=10.0
signal stamina_updated(value,max)

@export_category('thirst')
@export var thirst:=0.0
@export var max_thirst:=10.0
signal thirst_updated(value,max)

@export_category('hunger')
@export var hunger:=0.0
@export var max_hunger:=10.0
signal hunger_updated(value,max)


func _init() -> void:
	name = 'stats'
func _ready() -> void:
	owner = root
#	root.add_to_group('stats')
	set_interface()
	connect_goap_agent()


func change_health(delta):
	if delta == 0:return
	health = clampf(health + delta, 0, max_health)
	emit_signal(NL.health_updated, health, max_health)
	hurt_sfx(delta)
	if health <= 0:
		emit_signal('die')

func change_strength(delta):
	if delta == 0:return
	strength = clampf(strength + delta, 0, max_strength)
	emit_signal(NL.strength_updated, strength, max_strength)

func change_mana(delta):
	if delta == 0:return
	mana = clampf(mana + delta, 0, max_mana)
	emit_signal(NL.mana_updated, mana, max_mana)

func change_stamina(delta):
	if delta == 0:return
	stamina = clampf(stamina + delta, 0, max_stamina)
	emit_signal(NL.stamina_updated, stamina, max_stamina)

func change_thirst(delta):
	if delta == 0:return
	thirst = clampf(thirst + delta, 0, max_thirst)
	emit_signal(NL.thirst_updated, thirst, max_thirst)

func change_hunger(delta):
	if delta == 0:return
	hunger = clampf(hunger + delta, 0, max_hunger)
	emit_signal(NL.hunger_updated, hunger, max_hunger)


func set_interface():
	if has_health:
		root.set_meta('change_health', Callable(change_health))
	if has_strength:
		root.set_meta('change_mana', Callable(change_strength))
	if has_mana:
		root.set_meta('change_mana', Callable(change_mana))
	
	if has_stamina:
		root.set_meta('change_stamina', Callable(change_stamina))
	if has_thirst:
		root.set_meta('change_mana', Callable(change_thirst))
	if has_hunger:
		root.set_meta('change_hunger', Callable(change_hunger))

func connect_goap_agent():
	agent = get_node_or_null("../goap_agent")
	if agent == null: return
	if has_health:
		update_agent_health(health,max_health)
		connect(NL.health_updated,update_agent_health)
	if has_mana:
		update_agent_mana(mana,max_mana)
		connect(NL.mana_updated,update_agent_mana)
	if has_stamina:
		update_agent_stamina(stamina,max_stamina)
		connect(NL.stamina_updated,update_agent_stamina)	
	if has_hunger:
		update_agent_hunger(hunger,max_hunger)
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
