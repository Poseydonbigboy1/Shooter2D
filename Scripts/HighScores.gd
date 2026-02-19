extends Node2D

@onready var score_container = $CanvasLayer/ScoreContainer

func _ready():
	display_scores()

func display_scores():
	for child in score_container.get_children():
		child.queue_free()

	var scores = ScoreManager.get_scores()
	for i in range(scores.size()):
		var rank = i + 1
		var score_value = scores[i]
		
		var label = Label.new()
		label.text = str(rank) + ". " + str(score_value)
		label.add_theme_font_size_override("font_size", 60)
		label.horizontal_alignment = 1
		score_container.add_child(label)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scene/StartScene.tscn")
