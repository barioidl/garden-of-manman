extends MeshInstance3D

func _ready() -> void:
	set_button_color()

func set_button_color():
	var locked = $"../..".locked
	var mat = material_override.duplicate()
	mat.albedo_color = Color.DARK_RED if locked else Color.RED
	material_override = mat
