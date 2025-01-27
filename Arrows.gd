extends Control

@onready var Board:ChessBoard=$"../Board"
#Arrowinfo is ['Location ID'] = ArrowObject
@export var CoordInfo:Dictionary
@export var ArrowInfo:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func UpdateArrows():
	for eachArrow in ArrowInfo:
		CreateArrow(eachArrow,ArrowInfo[eachArrow])
	pass

func CreateArrow(ArrowName:String,ArrowStrength):
	var NewArrow:Arrow = load("res://Arrow.tscn").instantiate()
	add_child(NewArrow)
	NewArrow.name = ArrowName
	var ArrowOrigin = LocationToCoord(ArrowName.left(2))*50.0
	var ArrowDestination = LocationToCoord(ArrowName.right(2))*50.0
	var ArrowDelta = ArrowDestination-ArrowOrigin
	NewArrow.position = Vector2(ArrowOrigin.x,450.0-ArrowOrigin.y)
	NewArrow.ArrowDestination = Vector2(ArrowDelta.x,-ArrowDelta.y)
	NewArrow.Strength = ArrowStrength
	
func ClearArrows():
	ArrowInfo.clear()
	for eachArrow in get_children():
		eachArrow.queue_free()
		
func ClearInfo():
	CoordInfo.clear()
	
	
func LocationToCoord(Location:String):
	var File = Location[0]
	var Rank = Location[1]
	var FileCoord = 0
	match(File):
		'A':FileCoord = 1
		'B':FileCoord = 2
		'C':FileCoord = 3
		'D':FileCoord = 4
		'E':FileCoord = 5
		'F':FileCoord = 6
		'G':FileCoord = 7
		'H':FileCoord = 8
	return Vector2i(FileCoord,Rank.to_int())

func CoordToLocation(Coord:Vector2i):
	var File = 'Z'
	match Coord[0]:
		1:File = 'A'
		2:File = 'B'
		3:File = 'C'
		4:File = 'D'
		5:File = 'E'
		6:File = 'F'
		7:File = 'G'
		8:File = 'H'
	return File+'%s'%Coord[1]


#Received Msg is cleared to 'A1A2'
func _on_receive_coord(Nickname, Coord):
	CoordInfo[Nickname] = Coord
	ClearArrows()
	UpdateArrowInfo()
	UpdateArrows()
	pass # Replace with function body.

func UpdateArrowInfo():
	for eachCoordInfo in CoordInfo:
		if ArrowInfo.get(CoordInfo[eachCoordInfo]) != null:
			ArrowInfo[CoordInfo[eachCoordInfo]]+=1.0
		else: ArrowInfo[CoordInfo[eachCoordInfo]]=1.0
	for eachArrowInfo in ArrowInfo:
		ArrowInfo[eachArrowInfo] = ArrowInfo[eachArrowInfo]/CoordInfo.size()
	return


func _on_board_turn_changed(IsWhiteTurn):
	print(GetMaxCoord())
	ClearArrows()
	CoordInfo.clear()
	pass # Replace with function body.

func GetMaxCoord():
	if ArrowInfo.is_empty(): return 'A1H7'
	var MaxCoord = ArrowInfo.find_key(ArrowInfo.values().max())
	return MaxCoord


func _on_debug_button_pressed():
	_on_receive_coord('%.5f'%randf(),$"../Debug".text)

	pass # Replace with function body.
