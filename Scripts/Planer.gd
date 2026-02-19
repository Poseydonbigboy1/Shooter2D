extends CharacterBody2D
class_name Planer 
@export var health = 100
func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
func die():
	pass
