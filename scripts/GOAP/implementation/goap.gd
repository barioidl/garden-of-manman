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

func _enter_tree() -> void:
	print('tree enter')
func _exit_tree() -> void:
	print('tree exit')

func get_action_planner()->GOAPPlanner:
	return planner_action

func print_all_names():
	for i in planner_action.actions:
		print(i._name())


var disable_when_debug := false
#var file_path := "res://data/goap/goap weights.json"
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
	var current_position:=0
	while current_position < save_game.get_length():
		var json_string = save_game.get_line()
		current_position = save_game.get_position()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result != OK:
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
