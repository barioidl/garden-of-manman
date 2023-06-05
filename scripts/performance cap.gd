@tool
extends Node

func _process(delta: float) -> void:
	limit_billboard = 30
	
	limit_IK_solver = 10
	
	limit_goap_generate_plan = 1
	

var limit_billboard:=0
func allow_billboard()->bool:
	limit_billboard -= 1
	return limit_billboard >= 0

var limit_goap_generate_plan:=0
func allow_goap_planner()->bool:
	limit_goap_generate_plan -= 1
	return limit_goap_generate_plan >= 0

var limit_IK_solver:=0
func allow_IK()->bool:
	limit_IK_solver -= 1
	return limit_IK_solver >= 0
