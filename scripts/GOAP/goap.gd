extends Node
enum keys{
	is_hungry,
	is_low_hp,
	is_in_danger
	}
var planner_action = GOAPPlanner.new()

#var planner_dialogue = GOAPPlanner.new()

func _ready() -> void:
	planner_action.actions = [ActionFight.new(),GOAPAction.new()]

func get_action_planner()->GOAPPlanner:
	return planner_action
