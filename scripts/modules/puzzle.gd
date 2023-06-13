extends Node

var score := 0.0
@export var range:= 25

@onready var agent = get_parent()
@onready var root = $"../.."
var target:Node3D

func _ready() -> void:
	if !can_process():
		return
	set_interface()
	get_target()

var dt :=0.0
func _process(delta: float) -> void:
	dt = delta
	get_scores()

func set_interface():
	agent.set_local_state(NL.puzzle,self)
func get_target():
	target = get_tree().get_first_node_in_group(NL.player)

var score_cd:=0.0
func get_scores():
	if score_cd >0:
		score_cd -= dt
		return
	score_cd = 0.5
	var target_pos = target.global_position
	var root_pos = root.global_position
	var dist = root_pos.distance_to(target_pos)
	
	score = 1 - dist / range
	score = clampf(score,0,1)

func perform(local_state: Dictionary, dt: float)-> bool:
	var pos = root.global_position
	var point = WorldState.get_farest_node_3d('safepoints',pos)
	if point == null:
		return true
	if point.global_position.distance_squared_to(pos) > 1:
		Interface.attach_nav_agent(root,point)
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true
