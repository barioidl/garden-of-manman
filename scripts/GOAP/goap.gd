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

var available_slots:=0
func reached_limit()->bool:
	available_slots -= 1
	return available_slots < 0

func _ready() -> void:
	planner_action.actions = [
		ActionFight.new(),
		GOAPAction.new(),
		ActionFindFood.new(),
		ActionEatFood.new(),
	]

func _process(delta: float) -> void:
	available_slots = 3

func get_action_planner()->GOAPPlanner:
	return planner_action
