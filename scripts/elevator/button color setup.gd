extends MeshInstance3D

func _ready() -> void:
	set_button_color()

func set_button_color():
	var locked = $"../..".locked
	var mat :ShaderMaterial= material_override.duplicate()
	var color = Color.DARK_RED if locked else Color.RED
	mat.set("shader_parameter/albedo",color)
	material_override = mat

