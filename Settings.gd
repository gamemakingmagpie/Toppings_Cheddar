extends Panel

var IsWhite = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/LinkAddress.text = Global.ChannelID
	$VBoxContainer/HBoxContainer/StreamerNameInput.text = Global.StreamerName
	$VBoxContainer/HBoxContainer/ViewerNameInput.text = Global.ViewerName
	match Global.TimerTime:
		10:_on_5s_pressed()
		15:_on_10s_pressed()
		20:_on_15s_pressed()
		30:_on_20s_pressed()
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	Global.ChannelID = $VBoxContainer/LinkAddress.text
	get_tree().change_scene_to_file('res://Main.tscn')
	pass # Replace with function body.


func _on_check_box_pressed():
	IsWhite = !IsWhite
	Global.IsPlayerWhite = IsWhite
	if IsWhite:
		$VBoxContainer/HBoxContainer/CheckBox/Pawn.modulate = Color.WHITE
		$VBoxContainer/HBoxContainer/CheckBox/Pawn2.modulate = Color(0.15,0.15,0.15)
	else:
		$VBoxContainer/HBoxContainer/CheckBox/Pawn2.modulate = Color.WHITE
		$VBoxContainer/HBoxContainer/CheckBox/Pawn.modulate = Color(0.15,0.15,0.15)
	pass # Replace with function body.


func _on_5s_pressed():
	Global.TimerTime = 10
	$"VBoxContainer/HBoxContainer2/5s".modulate = Color(1.0,1.0,1.0,1.0)
	$"VBoxContainer/HBoxContainer2/10s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/10s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/15s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/15s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/20s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/20s".modulate = Color(1.0,1.0,1.0,0.1)
	pass # Replace with function body.

func _on_10s_pressed():
	Global.TimerTime = 15
	$"VBoxContainer/HBoxContainer2/10s".modulate = Color(1.0,1.0,1.0,1.0)
	$"VBoxContainer/HBoxContainer2/5s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/5s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/15s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/15s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/20s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/20s".modulate = Color(1.0,1.0,1.0,0.1)
	pass # Replace with function body.


func _on_15s_pressed():
	Global.TimerTime = 20
	$"VBoxContainer/HBoxContainer2/15s".modulate = Color(1.0,1.0,1.0,1.0)
	$"VBoxContainer/HBoxContainer2/5s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/5s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/10s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/10s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/20s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/20s".modulate = Color(1.0,1.0,1.0,0.1)
	
	pass # Replace with function body.


func _on_20s_pressed():
	Global.TimerTime = 30
	$"VBoxContainer/HBoxContainer2/20s".modulate = Color(1.0,1.0,1.0,1.0)
	$"VBoxContainer/HBoxContainer2/5s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/5s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/10s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/10s".modulate = Color(1.0,1.0,1.0,0.1)
	$"VBoxContainer/HBoxContainer2/15s".button_pressed = false
	$"VBoxContainer/HBoxContainer2/15s".modulate = Color(1.0,1.0,1.0,0.1)
	pass # Replace with function body.



func _on_streamer_name_input_text_changed():
	Global.StreamerName = $VBoxContainer/HBoxContainer/StreamerNameInput.text
	pass # Replace with function body.


func _on_viewer_name_input_text_changed():
	Global.ViewerName = $VBoxContainer/HBoxContainer/ViewerNameInput.text
	pass # Replace with function body.


func _on_start_game_end_pressed():
	get_tree().quit()
	pass # Replace with function body.
