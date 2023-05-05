extends Node

var planner_action = GOAPPlanner.new()
#var planner_dialogue = GOAPPlanner.new()

func _ready() -> void:
	planner_action.actions = []

func get_action_planner()->GOAPPlanner:
	return planner_action
