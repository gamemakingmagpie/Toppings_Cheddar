@tool
extends Line2D
class_name Arrow
@export var ArrowDestination:Vector2:
	set(value):
		ArrowDestination = value
		ChangeArrow()
@export var Name:String = 'A1A2'
@onready var ArrowHead := $ArrowHead
@export_range(0.0,1.0) var Strength:float = 1.0:
	set(value):
		Strength = value
		ChangeStrength()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.

func ChangeArrow():
	points[1]=ArrowDestination
	if ArrowHead:
		ArrowHead.position = points[1]
		ArrowHead.rotation = ArrowDestination.angle()+PI

	pass

func ChangeStrength():
	default_color = Color(0.2+Strength*0.8,0.2,1.0-Strength*0.8)
	width = Strength*10.0+5.0
	if ArrowHead:
		ArrowHead.default_color = Color(0.2+Strength*0.8,0.2,1.0-Strength*0.8)
		ArrowHead.width = Strength*10.0+5.0
		ArrowHead.points[0] = Vector2(width*2.0,width*2.0)
		ArrowHead.points[2] = Vector2(width*2.0,-width*2.0)
	pass
