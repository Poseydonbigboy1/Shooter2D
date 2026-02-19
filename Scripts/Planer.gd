extends CharacterBody2D
class_name Planer 
@export var health = 100
func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
func die():
	var root = get_tree().current_scene
	
	# Проверяем, есть ли у корня метод show_game_over
	if root.has_method("show_game_over"):
		root.show_game_over()
	
	# Удаляем объект (игрока или врага), чтобы он не висел в памяти
	queue_free()
