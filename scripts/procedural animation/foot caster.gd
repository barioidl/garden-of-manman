extends RayCast3D
@export var exception :CollisionObject3D
@onready var root = get_parent().root
func _ready() -> void:
	add_exception(exception)
