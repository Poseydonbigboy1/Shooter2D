extends Area2D
@export var speedBullet = 1000
@onready var anim = $AnimatedSprite2D
#@export var sprite: Texture2D
#@export var direction = Vector2.UP 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y * speedBullet * delta
	
func setTexture(texture: Texture2D):
	if texture: 
		$Sprite2D.texture = texture
