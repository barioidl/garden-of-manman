extends Node

var planner_action = GOAPPlanner.new()
#var planner_dialogue
#var planner_music
#var planner_tutorial
#var planner_animation
#var planner_items

func _ready() -> void:
	planner_action.actions = [
		ActionScream.new(),
		ActionFaceTarget.new(),
		ActionAttackTarget.new(),
		ActionPuzzle.new(),
		
		ActionFindFood.new(),
		ActionEatFood.new(),
	]
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(print_all_names)

func get_action_planner()->GOAPPlanner:
	return planner_action

func print_all_names():
	for i in planner_action.actions:
		print(i._name())
