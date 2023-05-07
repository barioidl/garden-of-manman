extends Node

enum keys{
	plan_width,
	plan_depth,
	
	has_food,
	hungriness,
	health,
	adrenaline,
	}

var planner_action = GOAPPlanner.new()
#var planner_dialogue
#var planner_music
#var planner_tutorial
#var planner_animation
#var planner_items

func _ready() -> void:
	planner_action.actions = [
		ActionFight.new(),
		GOAPAction.new(),
		ActionFindFood.new(),
		ActionEatFood.new(),
	]

func get_action_planner()->GOAPPlanner:
	return planner_action
