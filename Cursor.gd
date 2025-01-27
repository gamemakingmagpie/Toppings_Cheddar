extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	global_position = get_global_mouse_position()
