extends ItemOverworld

@export var password:Lock.types

func _ready() -> void:
	add_to_group('key')
	var tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_callback(get_color)

func get_color():
	var lock = get_tree().get_first_node_in_group('lock')
	$Sprite3D.modulate = lock.get_color(password)
