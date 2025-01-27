extends Panel
signal ReceiveCoord(Nickname,Coord)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func AddChat(text):
	var NewChat := Label.new()
	$VBoxContainer.add_child(NewChat)
	NewChat.text = text


func _on_chat_receiver_chat_received(Nickname:String, Msg:String):
	if Msg.length()!=5:return
	if not Msg.begins_with('!'):return
	if not ['A','B','C','D','E','F','G','H'].has(Msg[1]):return
	if not ['1','2','3','4','5','6','7','8'].has(Msg[2]):return
	if not ['A','B','C','D','E','F','G','H'].has(Msg[3]):return
	if not ['1','2','3','4','5','6','7','8'].has(Msg[4]):return
	AddChat(' %s : %s'%[Nickname,Msg])
	ReceiveCoord.emit(Nickname,Msg.right(4))
	pass # Replace with function body.
