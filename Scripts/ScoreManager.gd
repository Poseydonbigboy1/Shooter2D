extends Node

const SAVE_PATH = "user://scores.json"
const MAX_SCORES = 10

var scores = []

func _ready():
	load_scores()

func get_scores():
	return scores

func load_scores():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			scores = json.get_data()
		else:
			print("Error parsing scores.json: ", json.get_error_message())
	else:
		scores = []
		for i in range(MAX_SCORES):
			scores.append(0)

func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(scores))

func add_score(new_score):
	scores.append(new_score)
	scores.sort_custom(func(a, b): return a > b)
	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)
	save_scores()
