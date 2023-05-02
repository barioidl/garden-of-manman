extends ItemMount

@export var password:Lock.types

func _ready() -> void:
	add_to_group("key")
	var lock = get_tree().get_first_node_in_group('lock')
	$Sprite3D.modulate = lock.get_color(password)

func interact(body):
	body.interact(self)
