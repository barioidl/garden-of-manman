extends Node

var planner_action = GOAPPlanner.new()
#var planner_dialogue
#var planner_music
#var planner_tutorial
#var planner_animation
#var planner_items

func _ready() -> void:
	add_to_group(NL.on_quit)
	init_action_planner()
	load_all_actions()

func on_quit():
	save_all_actions()

func init_action_planner():
	planner_action.actions = [
		ActionScream.new(),
		ActionFaceTarget.new(),
		ActionAttackTarget.new(),
		ActionPuzzle.new(),
		
		ActionFindFood.new(),
		ActionEatFood.new(),
	]
func get_action_planner()->GOAPPlanner:
	return planner_action


var action_path := "res://data/goap/action weights.json"
func load_all_actions():
	_load(planner_action.actions,action_path)
func save_all_actions():
	_save(planner_action.actions,action_path)



var disable_when_debug := false
func _save(resources:Array, path:String):
	if disable_when_debug:
		if OS.is_debug_build():
			return
	var save_game = FileAccess.open(path, FileAccess.WRITE)
	var save_nodes = get_tree(). get_nodes_in_group(NL.goap_save_load)
	for node in resources:
		if !node.has_method("_save"):
			print(str(node.name) + "is missing a _save() function")
			continue
		var node_data = node._save()
		var json_string = JSON.stringify(node_data)
		save_game.store_line(json_string)

func _load(resources:Array, path:String):
	if disable_when_debug:
		if OS.is_debug_build():
			return
	if not FileAccess.file_exists(path):
			return 
	
	var save_game = FileAccess.open(path, FileAccess.READ)
	var current_position:=-1
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		current_position += 1
		
		var json = JSON.new()
		var error = json.parse(json_string)
		if error != OK:
			print("JSON Parse Error: ",json.get_error_line())
			continue
		
		var node_data = json.get_data()
		var target = resources[current_position]
		if target == null:
			print("target ain't exist")
			continue
		if !target.has_method("_load"):
			print("target has no _load()")
			continue
		target._load(node_data)
