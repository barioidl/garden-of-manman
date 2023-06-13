extends Node

var root
@onready var agent = get_parent()
var target:Node3D

@export var range:= 2.5
var score := 0.0

func _enter_tree() -> void:
	root = get_parent().root
func _ready() -> void:
	if !can_process():
		return
	set_interface()
	get_target()

var dt :=0.0
func _process(delta: float) -> void:
	dt = delta
#	get_scores()

func set_interface():
	agent.set_local_state(NL.jumpscare,self)

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


@export var scream_sfx:AudioList
func scream():
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,scream_sfx)
