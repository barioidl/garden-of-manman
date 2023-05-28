extends Node
class_name Stats

var root :Node3D
var agent : GOAPAgent

@export var has_health := true
@export var health := 10.0
@export var max_health := 10.0
signal health_updated(delta,value,max)
signal die()

@export var has_strength := true
@export var strength := 0.0
@export var max_strength := 10.0
signal strength_updated(delta,value,max)

@export var has_mana := true
@export var mana := 0.0
@export var max_mana := 10.0
signal mana_updated(delta,value,max)

@export var has_stamina := true#basically oxygen
@export var stamina := 10.0
@export var max_stamina := 10.0
signal stamina_updated(delta,value,max)

@export var has_thirst := true
@export var thirst := 0.0
@export var max_thirst := 10.0
signal thirst_updated(delta,value,max)

@export var has_hunger := true
@export var hunger := 0.0
@export var max_hunger := 10.0
signal hunger_updated(delta,value,max)


@export var priority_health := 1.0
@export var priority_strength := 0.75
@export var priority_mana := 0.5
@export var priority_stamina := 0.25
@export var priority_thirst := -0.6
@export var priority_hunger := -0.3

func _init() -> void:
	name = 'stats'
func _enter_tree() -> void:
	root = get_parent().root
	owner = root
	set_interface()
func _ready() -> void:
#	root.add_to_group('stats')
	connect_goap_agent()


func change_health(delta):
	if !has_health: return
	if delta == 0:return
	health = clampf(health + delta, 0, max_health)
	emit_signal(NL.health_updated, delta, health, max_health)
	hurt_sfx(delta)
	if health <= 0:
		emit_signal('die')
		Interface.reward_agent(root,-10)

func change_strength(delta):
	if !has_strength: return
	if delta == 0:return
	strength = clampf(strength + delta, 0, max_strength)
	emit_signal(NL.strength_updated, delta, strength, max_strength)

func change_mana(delta):
	if !has_mana: return
	if delta == 0:return
	mana = clampf(mana + delta, 0, max_mana)
	emit_signal(NL.mana_updated, delta, mana, max_mana)

func change_stamina(delta):
	if !has_stamina: return
	if delta == 0:return
	stamina = clampf(stamina + delta, 0, max_stamina)
	emit_signal(NL.stamina_updated, delta, stamina, max_stamina)

func change_thirst(delta):
	if !has_thirst: return
	if delta == 0:return
	thirst = clampf(thirst + delta, 0, max_thirst)
	emit_signal(NL.thirst_updated, delta, thirst, max_thirst)

func change_hunger(delta):
	if !has_hunger: return
	if delta == 0:return
	hunger = clampf(hunger + delta, 0, max_hunger)
	emit_signal(NL.hunger_updated, delta, hunger, max_hunger)

func reset():
	health = max_health
	strength = 0
	mana = 0
	stamina = max_stamina
	thirst = 0
	hunger = 0


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
	agent = Interface.get_goap_agent(root)
	if agent == null: return
	if has_health:
		update_agent_health(0,health,max_health)
		connect(NL.health_updated,update_agent_health)
	if has_strength:
		update_agent_mana(0,strength,max_strength)
		connect(NL.mana_updated,update_agent_strength)
	if has_mana:
		update_agent_mana(0,mana,max_mana)
		connect(NL.mana_updated,update_agent_mana)
	if has_stamina:
		update_agent_stamina(0,stamina,max_stamina)
		connect(NL.stamina_updated,update_agent_stamina)	
	if has_thirst:
		update_agent_hunger(0,thirst,max_thirst)
		connect(NL.hunger_updated,update_agent_thirst)
	if has_hunger:
		update_agent_hunger(0,hunger,max_hunger)
		connect(NL.hunger_updated,update_agent_hunger)

func update_agent_health(_delta,_value,_max):
	agent.set_local_state(NL.health,_value)
	agent.set_local_state(NL.max_health,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_health)

func update_agent_strength(_delta,_value,_max):
	agent.set_local_state(NL.strength,_value)
	agent.set_local_state(NL.max_strength,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_strength)

func update_agent_mana(_delta,_value,_max):
	agent.set_local_state(NL.mana,_value)
	agent.set_local_state(NL.max_mana,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_mana)

func update_agent_stamina(_delta,_value,_max):
	agent.set_local_state(NL.stamina,_value)
	agent.set_local_state(NL.max_stamina,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_stamina)

func update_agent_thirst(_delta,_value,_max):
	agent.set_local_state(NL.thirst,_value)
	agent.set_local_state(NL.max_thirst,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_thirst)

func update_agent_hunger(_delta,_value,_max):
	agent.set_local_state(NL.hunger,_value)
	agent.set_local_state(NL.max_hunger,_max)
	if _value > 0 and _value < _max:
		Interface.reward_agent(root,_delta * priority_hunger)



@export_category('sfx')
@export var hurt_sounds:AudioList
func hurt_sfx(delta:float):
	if delta >0: return
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,hurt_sounds)
