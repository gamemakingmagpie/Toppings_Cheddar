extends Button
class_name Square
var IsSelectable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_pressed():
	if IsSelectable:
		get_parent().SquarePressed(self)
		return
	if get_child_count()==0:return
	var Pawn:PieceBase = get_child(0)
	get_parent().PawnPressed(Pawn)
	pass # Replace with function body.
