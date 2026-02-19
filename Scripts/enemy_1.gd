extends Planer

signal died(score)

# Speed is now controlled by config, not exported
var speed = 300
@export var bullet: PackedScene
@onready var anim = $AnimatedSprite2D
@onready var MuzzleLeft= $MuzzleLeft
@onready var MuzzleRight = $MuzzleRight

# Default shooting parameters
var shots_per_burst = 1
var burst_cooldown = 2.0
var fire_rate = 0.1 # Time between shots in a burst
var bullet_speed = 500 # Default bullet speed

var burst_timer = 0.0
var shots_fired_in_burst = 0
var is_shooting_burst = false

func set_config(config: Dictionary):
	shots_per_burst = config.get("shots_per_burst", 1)
	burst_cooldown = config.get("burst_cooldown", 2.0)
	fire_rate = config.get("fire_rate", 0.1)
	# Set speeds from config
	speed = config.get("enemy_speed", 300)
	bullet_speed = config.get("bullet_speed", 500)
	# Reset timer to apply new cooldown
	burst_timer = burst_cooldown 

func _ready() -> void:
	set_collision_layer_value(3, true)
	add_to_group("enemies")
	anim.play("fly_enemy")

func shoot(Muzzle):
	var newBullet = bullet.instantiate()
	newBullet.direction = +1
	newBullet.shooter = self
	# Pass the speed to the bullet instance
	newBullet.set_speed(bullet_speed) 
	newBullet.global_position = Muzzle.global_position
	newBullet.rotation = rotation
	newBullet.set_collision_layer_value(4, true)
	newBullet.set_collision_mask_value(1, true)
	get_tree().current_scene.add_child(newBullet)
	newBullet.setAnimation("2")

func _process(delta: float) -> void:
	burst_timer += delta
	
	if burst_timer >= burst_cooldown and not is_shooting_burst:
		is_shooting_burst = true
		shots_fired_in_burst = 0
		start_burst()

func start_burst():
	while shots_fired_in_burst < shots_per_burst:
		shoot(MuzzleLeft)
		shoot(MuzzleRight)
		shots_fired_in_burst += 1
		if shots_fired_in_burst < shots_per_burst:
			await get_tree().create_timer(fire_rate).timeout
	
	is_shooting_burst = false
	burst_timer = 0.0
	
func calculate_score() -> int:
	# Formula to calculate score based on enemy stats
	var score = (speed * 0.1) + (shots_per_burst * 5) + ((1.0 / burst_cooldown) * 10)
	return int(score)

func die():
	emit_signal("died", calculate_score())
	queue_free()

func _physics_process(delta):
	var path_follower = get_parent()
	
	if path_follower is PathFollow2D:
		path_follower.progress += speed * delta
		
		if path_follower.progress_ratio >= 1.0:
			# Enemy that flies away gives no score and doesn't emit the died signal
			queue_free()
