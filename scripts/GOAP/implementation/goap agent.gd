extends Node
class_name GOAPAgent

var root:Node3D
var local_state:={}
var planner :GOAPPlanner

var goals:=[]:
	get:
		return goals
	set(value):
		goals = value
		goal_size = goals.size()

var current_goal:GOAPGoal
var current_plan:Array:
	get:
		return current_plan
	set(value):
		current_plan = value
		plan_size = current_plan.size()

var goal_size:=0
var plan_size:=0
var current_step:=0
enum a_states{start,perform,end}
var action_state:= a_states.start

@export var planner_limits:=Vector2(3,6)
var loop_plan:= false

@export var show_local_state := false
@onready var debug_display = get_node_or_null('../debug_display')

func _init() -> void:
	name = 'goap_agent'

func _enter_tree() -> void:
	root = get_parent().root
	set_interface()
	_load()

func _ready() -> void:
	add_to_group(NL.goap_save_load)
	planner = get_planner()
	init_local_state()

var dt:=0.0
func _process(delta: float) -> void:
	dt = delta
	generate_plan()
	follow_plan()

func _exit_tree() -> void:
	_save()


func set_interface():
	root.set_meta(NL.get_goap_agent,get_goap_agent)
	root.set_meta(NL.toggle_goap_agent,toggle_goap_agent)
	root.set_meta(NL.reward_agent,reward)

func get_goap_agent()->GOAPAgent:
	return self

func toggle_goap_agent(on:bool):
	var mode = Node.PROCESS_MODE_INHERIT 
	if !on:
		mode =  Node.PROCESS_MODE_DISABLED
	process_mode = mode

func reward(amount:=0.1):
	if current_goal == null:
		return
	_print('agent rewarded: ' + str(amount))
	current_goal.score += amount
	for action in current_plan:
		action.score += amount

func get_planner() -> GOAPPlanner:
	return Goap.get_action_planner()

func init_local_state():
	set_local_state(NL.root,root)
	set_local_state(NL.agent,self)
	set_local_state(NL.unique_steps,false)
	set_local_state(NL.plan_width,planner_limits.x)
	set_local_state(NL.plan_depth,planner_limits.y)

func set_local_state(key,value):
	if local_state.has(key):
		if local_state[key] == value:	return
	local_state[key] = value
	_print('set local state: '+ str(key)+', '+str(value))
	debug_local_state()

var follow_cd := 0.0
func follow_plan():
	if follow_cd > 0:
		follow_cd -= dt
		return
	if current_step >= plan_size:
		return
	var action :GOAPAction= current_plan[current_step]
	match action_state:
		a_states.perform:
			if !action.perform(local_state, dt):
				return
			action_state = a_states.end
		a_states.start:
			action.start(local_state)
			action_state = a_states.perform
		a_states.end:
			action.end(local_state)
			action_state = a_states.start
			current_step += 1
			action.score += 0.1
			current_goal.score += 0.1


var generate_cd :=0.0
func generate_plan():
	if generate_cd >0:
		generate_cd -= dt
		return
	if !PerformanceCap.allow_goap_planner(): return
	generate_cd = 1
	
	var best_goal = select_goal()
	if best_goal == null: return
	if best_goal == current_goal: 
		if !loop_plan:
			return
		elif current_step < plan_size:
			return
	current_goal = best_goal
	current_step = 0
	action_state = a_states.start
	
	current_goal.perform(local_state,dt)
	current_plan = planner.get_plan(current_goal, local_state)
	debug_plan()

func select_goal()-> GOAPGoal:
	goals.sort_custom(compare_goals)
	var iterations:= mini(3,goal_size)
	for i in iterations:
		var best_goal :GOAPGoal= goals[i]
		if !best_goal.is_valid(local_state): 
			continue
		if best_goal.priority(local_state) <= 0: 
			continue
		return best_goal
	return current_goal

func compare_goals(a:GOAPGoal,b:GOAPGoal)->bool:
	if !a.is_valid(local_state):
		return false
	return a.priority(local_state) > b.priority(local_state)

func debug_local_state():
	if !show_local_state: return
	if debug_display == null: return
	var keys = local_state.keys()
	var values = local_state.values()
	var iterations = local_state.size()
	var output:=''
	for i in iterations:
		output += keys[i]
		output += ': '
		output += get_string(values[i])
		output += ', '
	debug_display.set_content('local_state',output)

func debug_plan():
	if current_goal == null: return
	
	var goal_name = current_goal._name()
	var score := str(current_goal.priority(local_state))
	score = score.left(5)
	goal_name +=", score: " + score
	var plan = planner.print_plan(current_plan)
	
	_print('current goal' + goal_name)
	_print('plan: '+ plan)
	
	if debug_display == null: return
	debug_display.set_content('goal', goal_name)
	debug_display.set_content('plan',plan)

func get_string(_value)->String:
	if _value == null:
		return 'null'
	if _value is int:
		return str(_value)
	if _value is float:
		return str(_value)
	if _value is String:
		return _value
	if _value is Node:
		return _value.name
	return ''


func _save():
	if process_mode == PROCESS_MODE_DISABLED:
		_print('avoid saving dormant agent')
		return
	_print('agent saving goals')
	for goal in goals:
		goal._save()

func _load():
	_print('agent loading goals')
	for goal in goals:
		goal._load()

func _print(line:String):
	return
	print(line)
