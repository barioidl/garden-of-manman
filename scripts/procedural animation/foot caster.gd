extends RayCast3D
@onready var root = get_parent().root

func _ready() -> void:
	add_exception(root)
