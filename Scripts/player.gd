extends Planer

@export var bullet: PackedScene
@export var shoot_speed = 0.2
@export var bulletTexture: Texture2D
const SPEED = 900
@onready var anim = $AnimatedSprite2D
@onready var LeftMuzzle= $MLeft
@onready var RightMuzzle = $MRight
var lastShoot = 0.0
func _ready():
	set_collision_layer_value(1, true)
	
	anim.play("fly")

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("PlayerLeft"):
		velocity.x -= SPEED
	if Input.is_action_pressed("PlayerRight"):
		velocity.x += SPEED
	if Input.is_action_pressed("PlayerUp"):
		velocity.y -= SPEED
	if Input.is_action_pressed("PlayerDown"):
		velocity.y += SPEED
	velocity = velocity.normalized() * SPEED
	move_and_slide()
func shoot(Muzzle):
	var newBullet = bullet.instantiate()
	newBullet.direction = -1
	newBullet.shooter = self
	newBullet.global_position = Muzzle.global_position
	newBullet.rotation = rotation
	newBullet.set_collision_layer_value(2, true)
	newBullet.set_collision_mask_value(3, true)
	get_parent().add_child(newBullet)
	newBullet.setAnimation("1")
func _process(delta: float) -> void:
	lastShoot += delta
	if lastShoot >= shoot_speed:
		shoot(LeftMuzzle)
		shoot(RightMuzzle)
		lastShoot = 0.0
func die():
	var controller = get_tree().current_scene 
	if controller.has_method("show_game_over"):
		controller.show_game_over()
	queue_free() # Удаляем игрока
