extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_board_checked():
	var tween = create_tween()
	tween.tween_property(self,'modulate',Color(1.0,1.0,1.0,1.0),0.1)
	tween.tween_interval(0.5)
	tween.tween_property(self,'modulate',Color(1.0,1.0,1.0,0.0),0.1)
	pass # Replace with function body.
	


func _on_board_game_ended(IsWhiteWin):
	if IsWhiteWin == Global.IsPlayerWhite:
		$Label.text = '%s 승리'%Global.StreamerName
	else : $Label.text = '%s 승리'%Global.ViewerName
	var tween = create_tween()
	tween.tween_property(self,'modulate',Color(1.0,1.0,1.0,1.0),0.1)
	tween.tween_interval(5.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind('res://Settings.tscn'))
	pass # Replace with function body.
