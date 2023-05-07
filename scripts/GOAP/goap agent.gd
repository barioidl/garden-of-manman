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

@onready var debug_display = get_node_or_null('../debug_display')

func _init() -> void:
	name = 'goap_agent'

func _ready() -> void:
	planner = Goap.get_action_planner()

var time:=0.0
func _process(delta: float) -> void:
	time = delta
	generate_plan()
	follow_plan()

func set_local_state(key,value):
	if local_state.has(key):
		if local_state[key] == value:	return
	local_state[key] = value
	debug_local_state()

func follow_plan():
	if current_step >= plan_size:
		current_step=0
		return
	var completed = current_plan[current_step].perform(local_state,time)
	if completed:
		current_step += 1

var tween_plan :Tween
func generate_plan():
	if tween_plan != null:return
	tween_plan = create_tween()
	tween_plan.tween_interval(1.0)
	tween_plan.tween_callback(func(): tween_plan = null)
	
	var best_goal = select_goal()
	if best_goal == null: return
	if best_goal == current_goal: return
	current_goal = best_goal
	
	current_plan = planner.get_plan(current_goal, local_state)
	current_step = 0
	
	debug_plan()

func select_goal()-> GOAPGoal:
	goals.sort_custom(compare_goals)
	var iterations:= min(3,goal_size)
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
	if debug_display == null: return
	var keys = local_state.keys()
	var values = local_state.values()
	var iterations = local_state.size()
	var output:=''
	var key_strings = Goap.keys.keys()
	for i in iterations:
		output += key_strings[keys[i]]
		output += ': '
		output += str(values[i])
		output += ', '
	debug_display.set_content('local_state',output)

func debug_plan():
	if debug_display == null: return
	var content = planner.print_plan(current_plan)
	debug_display.set_content('goap_plan',content)
	debug_display.set_content('current_goal', current_goal.name())
