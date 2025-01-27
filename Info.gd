extends Control

var TurnTime = 20.0;
@onready var TurnLabel := $TurnLabel
@onready var TimerBar := $ProgressBar
@onready var TimerLabel := $ProgressBar/Label
var TurnTimer = 0.0;
# Called when the node enters the scene tree for the first time.
signal TimeOut
func _ready():
	TurnTime = Global.TimerTime
	TurnLabel.text  = '%s 차례'%Global.StreamerName if Global.IsPlayerWhite else '%s 차례'%Global.ViewerName
	StartTimer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	TimerLabel.text = '%.0f'%TurnTimer
	TimerBar.value = TurnTimer
	if TurnTimer == 0 : return
	if(TurnTimer-delta)*TurnTimer<0:
		TurnTimer = 0
		emit_signal('TimeOut')
		return
	TurnTimer -= delta
	pass

func StartTimer():
	TurnTimer = TurnTime
	TimerBar.max_value = TurnTime
	TimerBar.value = TurnTime
	pass


func _on_board_turn_changed(IsWhiteTurn:bool):
	TurnLabel.text  = '%s 차례'%Global.StreamerName if IsWhiteTurn==Global.IsPlayerWhite else '%s 차례'%Global.ViewerName
	if IsWhiteTurn: TurnLabel.modulate = Color.WHITE
	else: TurnLabel.modulate=Color.BLACK
	StartTimer()
	pass # Replace with function body.
