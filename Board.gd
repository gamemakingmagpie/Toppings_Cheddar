extends Control
class_name ChessBoard
var SelectedPawn:PieceBase = null
var EnPassantPawn:PieceBase = null
var EnPassantSquare:Square = null
var EnPassantCapture:Square = null
var IsWhiteTurn = true
var IsPlayerWhite = true
var IsGameEnd=false

var CastlingC1 = false
var CastlingG1 = false
var CastlingC8 = false
var CastlingG8 = false


@onready var WhiteKing = $E1/Pawn
@onready var BlackKing = $E8/Pawn
signal TurnChanged(IsWhiteTurn:bool)
signal GameEnded(IsWhiteWin:bool)
signal Checked()
signal PawnMoved()
const MOVE_TIME = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	IsPlayerWhite = Global.IsPlayerWhite
	pass # Replace with function body.

func PawnPressed(Pawn):
	if IsGameEnd:return
	if IsWhiteTurn!=IsPlayerWhite:return
	if Pawn.IsWhite!=IsPlayerWhite:return
	if Pawn.IsWhite!=IsWhiteTurn:return
	ClearBoard()
	SelectedPawn = Pawn
	ShowPossibleMoves(GetPossibleMoves(Pawn))
	pass

func GetPossibleMoves(Pawn:PieceBase):
	var MovableSquares:Array = []
	if Pawn == null : return MovableSquares
	match(Pawn.Name):
		'Pawn':
			var a = 1 if Pawn.IsWhite else -1
			var Coord:Vector2i = Pawn.GetCoord()
			#Movement
			if get_node(Pawn.CoordToLocation(Coord+Vector2i(0,a))).get_child_count()==0:
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,a)))
				#2 Spaces if first move
				if Pawn.IsFirstMove:
					if get_node(Pawn.CoordToLocation(Coord+Vector2i(0,a*2))).get_child_count()==0:
						EnPassantSquare = get_node(Pawn.CoordToLocation(Coord+Vector2i(0,a*2)))
						MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,a*2)))
			#Attack Only Move
			if Coord.x<8 and get_node(Pawn.CoordToLocation(Coord+Vector2i(1,a))).get_child_count()>0:
				if get_node(Pawn.CoordToLocation(Coord+Vector2i(1,a))).get_child(0).IsWhite != Pawn.IsWhite:
					MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(1,a)))
			if Coord.x>1 and get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,a))).get_child_count()>0:
				if get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,a))).get_child(0).IsWhite != Pawn.IsWhite:
					MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-1,a)))
			#EnPassant
			if Coord.x<8 and get_node(Pawn.CoordToLocation(Coord+Vector2i(1,0))).get_child_count()>0:
				if get_node(Pawn.CoordToLocation(Coord+Vector2i(1,0))).get_child(0).IsWhite != Pawn.IsWhite:
					if get_node(Pawn.CoordToLocation(Coord+Vector2i(1,0))).get_child(0) == EnPassantPawn:
						MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(1,a)))
						EnPassantCapture = get_node(Pawn.CoordToLocation(Coord+Vector2i(1,a)))
			if Coord.x>1 and get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,0))).get_child_count()>0:
				if get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,0))).get_child(0).IsWhite != Pawn.IsWhite:
					if get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,0))).get_child(0) == EnPassantPawn:
						MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-1,a)))
						EnPassantCapture = get_node(Pawn.CoordToLocation(Coord+Vector2i(-1,a)))
		'Rook':
			var Coord:Vector2i = Pawn.GetCoord()
			var i = 1
			while Coord.x+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,0)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,0)))
				i+=1
			i = 1
			while Coord.x-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,0)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,0)))
				i+=1
			i = 1
			while Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(0,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,i)))
				i+=1
			i=1
			while Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(0,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,-i)))
				i+=1
		'Knight':
			for eachDelta in [Vector2i(1,2),Vector2i(1,-2),Vector2i(-1,2),Vector2i(-1,-2),Vector2i(2,1),Vector2i(2,-1),Vector2i(-2,1),Vector2i(-2,-1)]:
				var DestinationCoord = Pawn.GetCoord()+eachDelta
				if DestinationCoord.x<1 or DestinationCoord.x>8:continue
				if DestinationCoord.y<1 or DestinationCoord.y>8:continue
				var DestinationSquare:Square = get_node(Pawn.CoordToLocation(DestinationCoord))
				if DestinationSquare.get_child_count()>0:
					if DestinationSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(DestinationSquare.get_name())
				else:
					MovableSquares.append(DestinationSquare.get_name())
		'Bishop':
			var Coord:Vector2i = Pawn.GetCoord()
			var i = 1
			while Coord.x+i<9 and Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,i)))
				i+=1
			i = 1
			while Coord.x-i>0 and Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,i)))
				i+=1
			i=1
			while Coord.x+i<9 and Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,-i)))
				i+=1
			i = 1
			while Coord.x-i>0 and Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,-i)))
				i+=1
		'Queen':			
			var Coord:Vector2i = Pawn.GetCoord()
			var i = 1
			while Coord.x+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,0)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,0)))
				i+=1
			i = 1
			while Coord.x-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,0)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,0)))
				i+=1
			i = 1
			while Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(0,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,i)))
				i+=1
			i=1
			while Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(0,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(0,-i)))
				i+=1
			i=1
			while Coord.x+i<9 and Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,i)))
				i+=1
			i = 1
			while Coord.x-i>0 and Coord.y+i<9:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,i)))
				i+=1
			i=1
			while Coord.x+i<9 and Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(i,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(i,-i)))
				i+=1
			i = 1
			while Coord.x-i>0 and Coord.y-i>0:
				var CheckSquare:Square = get_node(Pawn.CoordToLocation(Coord+Vector2i(-i,-i)))
				if CheckSquare.get_child_count()>0:
					if CheckSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(CheckSquare.get_name())
						break
					else:	break
				MovableSquares.append(Pawn.CoordToLocation(Coord+Vector2i(-i,-i)))
				i+=1
		'King':
			for eachDelta in [Vector2i(1,1),Vector2i(1,0),Vector2i(1,-1),Vector2i(0,1),Vector2i(0,-1),Vector2i(-1,1),Vector2i(-1,0),Vector2i(-1,-1)]:
				var DestinationCoord = Pawn.GetCoord()+eachDelta
				if DestinationCoord.x<1 or DestinationCoord.x>8:continue
				if DestinationCoord.y<1 or DestinationCoord.y>8:continue
				var DestinationSquare:Square = get_node(Pawn.CoordToLocation(DestinationCoord))
				if DestinationSquare.get_child_count()>0:
					if DestinationSquare.get_child(0).IsWhite != Pawn.IsWhite:
						MovableSquares.append(DestinationSquare.get_name())
				else:
					MovableSquares.append(DestinationSquare.get_name())
			#Castling
			if IsWhiteTurn:
				if get_node('E1').get_child_count()>0:
					var King = get_node('E1').get_child(0)
					if get_node('A1').get_child_count()>0:
						var Rook_A = get_node('A1').get_child(0)
						if King.IsFirstMove  and !CheckCheck('E1',true):
							if Rook_A.IsFirstMove:
								if get_node("B1").get_child_count()==0 and !CheckCheck('B1',true):
									if get_node("C1").get_child_count()==0 and !CheckCheck('C1',true):
										if get_node("D1").get_child_count()==0 and !CheckCheck('D1',true):
											MovableSquares.append('C1')
											CastlingC1 = true
										pass
					if get_node('H1').get_child_count()>0:
						var Rook_H = get_node('H1').get_child(0)
						if King.IsFirstMove  and !CheckCheck('E1',true):
							if Rook_H.IsFirstMove:
								if get_node("F1").get_child_count()==0 and !CheckCheck('F1',true):
									if get_node("G1").get_child_count()==0 and !CheckCheck('G1',true):
										MovableSquares.append('G1')
										CastlingG1 = true
			else:#BlackCastle
				if get_node('E8').get_child_count()>0:
					var King = get_node('E8').get_child(0)
					if get_node('A8').get_child_count()>0:
						var Rook_A = get_node('A8').get_child(0)
						if King.IsFirstMove and !CheckCheck('E8',false):
							if Rook_A.IsFirstMove:
								if get_node("B8").get_child_count()==0 and !CheckCheck('B8',false):
									if get_node("C8").get_child_count()==0 and !CheckCheck('C8',false):
										if get_node("D8").get_child_count()==0 and !CheckCheck('D8',false):
											MovableSquares.append('C8')
											CastlingC8 = true
										pass
					if get_node('H8').get_child_count()>0:
						var Rook_H = get_node('H8').get_child(0)
						if King.IsFirstMove and !CheckCheck('E8',false):
							if Rook_H.IsFirstMove:
								if get_node("F8").get_child_count()==0 and !CheckCheck('F8',false):
									if get_node("G8").get_child_count()==0 and !CheckCheck('G8',false):
										MovableSquares.append('G8')
										CastlingG8 = true
	#If Moving to location results in check, you can't move there

	return MovableSquares

func ShowPossibleMoves(MovableSquares):
	for eachSquares in MovableSquares:
		EnableSquare(eachSquares)
			
func EnableSquare(Location:String):
	var MovableSquare:Square = get_node(Location)
	MovableSquare.modulate = Color.YELLOW_GREEN
	MovableSquare.IsSelectable = true
	pass
	
func ClearBoard():
	SelectedPawn = null
	for eachChild in get_children():
		eachChild.modulate = Color.WHITE
		eachChild.IsSelectable = false
		EnPassantSquare = null
	CastlingC1 = false
	CastlingG1 = false
	CastlingC8 = false
	CastlingG8 = false
		

func SquarePressed(PressedSquare:Square):
	if IsGameEnd:return
	if SelectedPawn == null:return
	if PressedSquare == EnPassantSquare:
		EnPassantPawn = SelectedPawn
	if PressedSquare == EnPassantCapture:
		EnPassantPawn.Knockout()
		EnPassantPawn = null
		EnPassantCapture = null
		EnPassantSquare = null
	SelectedPawn.IsFirstMove = false
	if PressedSquare.get_child_count()>0:
		if PressedSquare.get_child(0).Name == 'King':
			GameEnded.emit(not PressedSquare.get_child(0).IsWhite)
		PressedSquare.get_child(0).Knockout()
	SelectedPawn.reparent(PressedSquare)
	var tween = create_tween().parallel()
	tween.tween_property(SelectedPawn,'position',Vector2(0,0),MOVE_TIME)
	if SelectedPawn.Name == 'Pawn':
		if SelectedPawn.IsWhite and PressedSquare.get_name().right(1) == '8': SelectedPawn.Name = 'Queen'
		if !SelectedPawn.IsWhite and PressedSquare.get_name().right(1) == '1': SelectedPawn.Name = 'Queen'
	if PressedSquare.name=='C1' and CastlingC1:
		get_node("A1").get_child(0).reparent(get_node('D1'))
		tween.tween_property(get_node('D1').get_child(0),'position',Vector2(0,0),MOVE_TIME)
	if PressedSquare.name=='G1' and CastlingG1:
		get_node("H1").get_child(0).reparent(get_node('F1'))
		tween.tween_property(get_node('F1').get_child(0),'position',Vector2(0,0),MOVE_TIME)
	if PressedSquare.name=='C8' and CastlingC8:
		get_node("A8").get_child(0).reparent(get_node('D8'))
		tween.tween_property(get_node('D8').get_child(0),'position',Vector2(0,0),MOVE_TIME)
	if PressedSquare.name=='G8' and CastlingG8:
		get_node("H8").get_child(0).reparent(get_node('F8'))
		tween.tween_property(get_node('F8').get_child(0),'position',Vector2(0,0),MOVE_TIME)
	PawnMoved.emit()
	if CheckCheck(WhiteKing.get_parent().name,true):	
		print("Check!!")
		Checked.emit()
	if CheckCheck(BlackKing.get_parent().name,false):
		print("Check!!")
		Checked.emit()
		
	ClearBoard()
	ChangeTurn()

func _on_game_ended(IsWhiteWin):
	IsGameEnd = true
	pass # Replace with function body.

func ChangeTurn():
	IsWhiteTurn = !IsWhiteTurn
	TurnChanged.emit(IsWhiteTurn)
	pass

#Move Pawn by entering String, Enter Example !B7B5
func MovePawn(Move:String):
	var PawnLocation = Move[0]+Move[1]
	var MoveLocation = Move[2]+Move[3]
	SelectedPawn = get_node(PawnLocation).get_child(0)
	var MoveSquare = get_node(MoveLocation)
	var MovableSquares:PackedStringArray= GetPossibleMoves(SelectedPawn) 
	prints('Movable Squares : ',MovableSquares)
	if MovableSquares.has(MoveLocation):	SquarePressed(MoveSquare)
	else: ChangeTurn()
	pass

#Check if (IsWhite) King is being checked. True if Check, False if not check.
func CheckCheck(CheckLocation:String,IsWhite:bool):
	prints("Checking Check at Location : ", CheckLocation)
	if SelectedPawn!=WhiteKing and SelectedPawn!=BlackKing:
		prints(SelectedPawn.Name,GetPossibleMoves(SelectedPawn))
		if GetPossibleMoves(SelectedPawn).has(CheckLocation):
			return true
	for eachSquare in get_children():
		if eachSquare.get_child_count()==0:continue
		var Pawn:PieceBase = eachSquare.get_child(0)
		if Pawn.IsWhite==IsWhite:continue
		if Pawn == WhiteKing:continue
		if Pawn == BlackKing:continue
		prints(Pawn.Name,GetPossibleMoves(Pawn))
		if GetPossibleMoves(Pawn).has(CheckLocation):
			return true
	return false



func _on_info_time_out():
	if IsWhiteTurn != IsPlayerWhite:
		var MoveCoord:String = $"../Arrows".GetMaxCoord()
		if get_node(MoveCoord.left(2)).get_child_count()>0:
			if get_node(MoveCoord.left(2)).get_child(0).IsWhite != IsPlayerWhite:
				MovePawn(MoveCoord)
				return
	ChangeTurn()
	pass # Replace with function body.
