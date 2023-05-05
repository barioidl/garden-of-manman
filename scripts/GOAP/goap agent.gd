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

func _ready() -> void:
	pass 

var dt:=0.0
func _process(delta: float) -> void:
	dt = delta
	calculate_goal()
	follow_plan()

func follow_plan():
	if current_step >= plan_size:return
	var completed = current_plan[current_step].perform(self_state,dt)
	if completed:
		current_step += 1

func calculate_goal():
	var best_goal = select_plan()
	if best_goal == null: return
	var planner :GOAPPlanner= Goap.get_action_planner()
	current_plan = planner.get_plan(best_goal,self_state)
	current_step = 0
#	var goal = goals[goal_iteration]
#	if !goal.is_valid(): return
	
	

func select_plan()-> GOAPGoal:
	var best_goal:GOAPGoal
	var max_score:=0.0
	for goal in goals:
		if !goal.is_valid(): continue
		var score = goal.priority()
		if score > max_score:
			max_score = score
			best_goal = goal
	return best_goal
