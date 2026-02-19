extends Planer
@export var speed = 300
@export var bullet: PackedScene
@onready var anim = $AnimatedSprite2D
@export var shoot_speed = 0.8
@onready var MuzzleLeft= $MuzzleLeft
@onready var MuzzleRight = $MuzzleRight
var lastshoot = 0.0


func _ready() -> void:
	set_collision_layer_value(3, true)
	add_to_group("enemies")
	anim.play("fly_enemy")

func shoot(Muzzle):
	var newBullet = bullet.instantiate()
	newBullet.direction = +1
	newBullet.shooter = self
	newBullet.global_position = Muzzle.global_position
	newBullet.rotation = rotation
	newBullet.set_collision_layer_value(4, true)
	newBullet.set_collision_mask_value(1, true)
	get_tree().current_scene.add_child(newBullet)
	#get_parent().add_child(newBullet)
	newBullet.setAnimation("2")

func _process(delta: float) -> void:
	lastshoot += delta
	if lastshoot >= shoot_speed:
		shoot(MuzzleLeft)
		shoot(MuzzleRight)
		lastshoot = 0.0
func die():
	queue_free()
func _physics_process(delta):
	var path_follower = get_parent()
	
	# Проверяем, что враг действительно внутри PathFollow2D
	if path_follower is PathFollow2D:
		# Двигаем вагончик вперед
		path_follower.progress += speed * delta
		
		# Если доехали до конца пути
		if path_follower.progress_ratio >= 1.0:
			die()
