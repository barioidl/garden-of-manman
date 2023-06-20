extends StaticBody3D
@export var password :Lock.types
@export var lock :Node3D
@export var door_meshes:Array

func _ready() -> void:
	set_up()

func set_up():
	lock.password=password
	var door_color :Color=lock.get_color(password)
	for mesh in door_meshes:
		mesh = get_node_or_null(mesh)
		if mesh == null:
			continue
		var material = mesh.material_override.duplicate()
		material.set("shader_parameter/albedo",door_color)
		material.set("shader_parameter/emission",door_color)
		mesh.material_override = material

signal lock_updated(state)
@export var door_open_sfx:AudioList
@export var door_close_sfx:AudioList
func updated(open):
	emit_signal("lock_updated",open)
	var pos = global_position
	var sfx = door_open_sfx if open else door_close_sfx
	var player = AudioPool.create_sound_3d(pos,sfx)
