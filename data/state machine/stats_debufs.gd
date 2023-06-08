extends Node

var root:Node3D
var stats :Stats
var platformer :Platformer

@export var tick_duration:=1.0


func _enter_tree() -> void:
	root =  get_parent().root
	
func _ready() -> void:
	stats = get_parent()
	platformer = root.get_node('platformer')
	platformer.connect(NL.on_state_changed,on_state_changed)

var cd := 0.0
func _process(delta: float) -> void:
	if cd >0:
		cd -= delta
		return
	cd = tick_duration
	heal()
	increase_hunger()
#	increase_thirst()

var comsumption_speed := 1.0
func on_state_changed(_state:StringName):
	match _state:
		NL.idle:
			comsumption_speed = 2
		NL.walk:
			comsumption_speed = 1
		NL.sneak:
			comsumption_speed = 1.25
		NL.sprint:
			comsumption_speed = 0.75
		NL.jump:
			comsumption_speed = 0.5
		NL.fall:
			comsumption_speed = 1.4

var hunger_tick := 0
func increase_hunger():
	if hunger_tick >0: 
		hunger_tick -= 1
		return
	hunger_tick = 20 * comsumption_speed
	
	if stats.hunger < stats.max_hunger:
		stats.change_hunger(1)
		return
	if stats.health >0:
		stats.change_health(-1)
		hunger_tick *= 0.5


var thirst_tick := 0
func increase_thirst():
	if thirst_tick >0:
		thirst_tick -= 1
		return
	thirst_tick = 10 * comsumption_speed
	
	if stats.thirst < stats.max_thirst:
		stats.change_thirst(1)
	else:
		stats.change_health(-1)
		thirst_tick *= 0.5

var heal_tick := 0
@export var heal_amount := 1.0
@export var heal_cost := 0.5
func heal():
	if heal_tick > 0:
		heal_tick -= 1
		return
	heal_tick = 5
	if stats.health >= stats.max_health:
		heal_tick *= 2
		return
	if stats.hunger >= stats.max_hunger:
		heal_tick *= 2
		return
	stats.change_health(heal_amount)
	stats.change_hunger(heal_cost)
