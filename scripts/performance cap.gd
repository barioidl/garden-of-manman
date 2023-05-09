@tool
extends Node

func _process(delta: float) -> void:
	limit_billboard_select = 10
	limit_billboard_rotate = 30
	
	limit_IK_solver = 10
	
	limit_goap_generate_plan = 1
	

var limit_billboard_select:=0
func allow_billboard_select()->bool:
	limit_billboard_select -= 1
	return limit_billboard_select >= 0

var limit_billboard_rotate:=0
func allow_billboard_rotate()->bool:
	limit_billboard_rotate -= 1
	return limit_billboard_rotate >= 0

var limit_goap_generate_plan:=0
func allow_goap_planner()->bool:
	limit_goap_generate_plan -= 1
	return limit_goap_generate_plan >= 0

var limit_IK_solver:=0
func allow_IK()->bool:
	limit_IK_solver -= 1
	return limit_IK_solver >= 0
