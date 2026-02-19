extends Node

class_name LevelGenerator

var level_data: Dictionary
var current_wave_index = 0

signal wave_cleared
signal spawn_enemy(choosen_path: Path2D)

func load_level_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			level_data = json.get_data()
		else:
			print("Error parsing level data JSON: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())

func start_next_wave():
	if level_data and current_wave_index < level_data.waves.size():
		var wave = level_data.waves[current_wave_index]
		current_wave_index += 1
		spawn_wave(wave)

func spawn_wave(wave_data: Dictionary):
	print("Старт волны №", current_wave_index, ". Врагов: ", wave_data.enemy_count)
	for i in range(wave_data.enemy_count):
		emit_signal("spawn_enemy", null) # We let the GameController decide the path
		await get_tree().create_timer(wave_data.spawn_delay).timeout

func has_more_waves() -> bool:
	return level_data and current_wave_index < level_data.waves.size()
