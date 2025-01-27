extends Node
class_name FileSystemUtils

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func read_text_from(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var content: String = file.get_as_text()
	file.close()
	return content
	
