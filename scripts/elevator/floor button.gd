extends Button3d

@export var offset_height:=-1.0
@export var working :=true
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	super._process(delta)

func interact(user):
	if !working:
		return
	super.interact(user)
