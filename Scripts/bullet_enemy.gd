extends Area2D
@export var speedBullet = 1000
@onready var anim1 = $AnimatedSprite2Dtype1
@onready var anim2 = $AnimatedSprite2Dtype2
var direction = 1
var shooter: Node2D
var damage = 60
#@export var sprite: Texture2D
#@export var direction = Vector2.UP 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass#anim.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.y * speedBullet * delta * direction
	
func setAnimation(animationType: String):
	anim1.hide()
	anim2.hide()
	if animationType == "1":
		anim1.show()
	elif animationType == "2":
		anim2.show()
	else: anim1.show()

func set_speed(new_speed: float):
	speedBullet = new_speed


func _on_body_entered(area) -> void:
	if area.has_method("take_damage"): #and area != shooter and shooter.is_in_group(""):
		area.take_damage(damage)
		queue_free()
