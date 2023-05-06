extends Node
class_name GOAPAgent

var root:Node3D
var self_state:={}

var goals:=[]:
	get:
		return goals
	set(value):
		goals = value

var current_goal:GOAPGoal
var current_plan:Array:
	get:
		return current_plan
	set(value):
		current_plan = value
		plan_size = current_plan.size()
var plan_size:=0
var current_step:=0

@onready var debug_display = get_node_or_null('../debug_display')

func _ready() -> void:
	pass

var time:=0.0
func _process(delta: float) -> void:
	time = delta
	generate_plan()
	follow_plan()

func follow_plan():
	return
	if current_step >= plan_size:return
	var completed = current_plan[current_step].perform(self_state,time)
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
	var planner :GOAPPlanner= Goap.get_action_planner()
	current_plan = planner.get_plan(best_goal,self_state)
	current_step = 0
	
	if debug_display != null:
		var content = planner.print_plan(current_plan)
		debug_display.set_content('goap_plan',content)

func select_goal()-> GOAPGoal:
	goals.sort_custom(compare_goals)
	var best_goal :GOAPGoal= goals[0]
	if !best_goal.is_valid(): 
		return current_goal
	if best_goal.priority() <= 0: 
		return current_goal
	return best_goal

#var tween_sort:Tween
#func sort_goals():
#	if tween_sort != null:return
#	tween_sort = create_tween()
#	tween_sort.tween_interval(1.0)
#	tween_sort.tween_callback(func(): tween_sort = null)
#
#	goals.sort_custom(compare_goals)

func compare_goals(a:GOAPGoal,b:GOAPGoal)->bool:
	if !a.is_valid():
		return false
	return a.priority() > b.priority()
