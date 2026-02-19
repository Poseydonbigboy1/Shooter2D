extends Node2D

@export var enemy_scene: PackedScene
@export var available_paths: Array[Path2D]
@export var PlayerScene: PackedScene
@onready var PlayerSpawnMarker = $PlayerSpawn

var level_generator = LevelGenerator.new()
var enemies_alive = 0 # Счетчик живых врагов

func _ready() -> void:
	add_child(level_generator)
	level_generator.load_level_data("res://level_data.json")
	level_generator.spawn_enemy.connect(spawn_enemy)
	
	var Player = PlayerScene.instantiate()
	Player.global_position = PlayerSpawnMarker.global_position
	get_tree().current_scene.add_child(Player)
	
	start_next_wave()

func spawn_enemy(choosen_path: Path2D = null): # Path is now optional
	if choosen_path == null:
		choosen_path = available_paths.pick_random()
		
	var follower = PathFollow2D.new()
	follower.loop = false
	follower.rotates = false
	choosen_path.add_child(follower)
	var enemy = enemy_scene.instantiate()
	enemy.scale = Vector2(0.5 , 0.5)
	follower.add_child(enemy)
	enemy.position = Vector2.ZERO
	enemies_alive += 1
	enemy.tree_exited.connect(_on_enemy_exited)

func _on_enemy_exited():
	enemies_alive -= 1
	
	if enemies_alive == 0:
		print("Волна зачищена!")
		if level_generator.has_more_waves():
			print("Следующая через 3 секунды...")
			start_timer_for_next_wave()
		else:
			print("Все волны пройдены! Победа!")

func start_timer_for_next_wave():
	if is_inside_tree():
		await get_tree().create_timer(3.0).timeout
		start_next_wave()

func start_next_wave():
	level_generator.start_next_wave()
	
func _process(delta: float) -> void:
	pass
