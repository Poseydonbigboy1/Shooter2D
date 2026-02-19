extends Area2D
var speed = 1000 # Default speed
@onready var anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position -= transform.y * speed * delta
	
func set_speed(new_speed: float):
	speed = new_speed

func setTexture(texture: Texture2D):
	if texture: 
		$Sprite2D.texture = texture
