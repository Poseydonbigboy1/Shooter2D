extends Node2D

@export var enemy_scene: PackedScene
@export var available_paths: Array[Path2D]
@export var PlayerScene: PackedScene
@onready var PlayerSpawnMarker = $PlayerSpawn
@onready var game_over_screen = $GameOver # РОМА


var current_wave = 0
var enemies_alive = 0 # Счетчик живых врагов
var is_wave_spawning = false # Чтобы не запустить волну дважды
var need_new_wave = false

func spawn_enemy():
	var choosen_path = available_paths.pick_random()
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
	
	# Если врагов не осталось И спаун волны закончен (все уже вышли)
	if enemies_alive == 0:
		print("Волна зачищена! Следующая через 3 секунд...")
		if current_wave <=3:
			start_timer_for_next_wave()

func start_timer_for_next_wave():
	# Создаем таймер на 3 секунд
	if is_inside_tree():
		await get_tree().create_timer(3.0).timeout
		# Когда время вышло — запускаем новую волну
		start_next_wave()


func _ready() -> void:
	var Player = PlayerScene.instantiate()
	Player.global_position = PlayerSpawnMarker.global_position
	get_tree().current_scene.add_child(Player)
	start_next_wave()
	game_over_screen.hide() # РОМА
func show_game_over():
	game_over_screen.show()
	get_tree().paused = true # РОМА
func start_next_wave():
	current_wave += 1
	# Формула количества: n + 1 (если волна 1 -> 2 врага, волна 2 -> 3 врага)
	var count_to_spawn = current_wave + 1
	print("Старт волны №", current_wave, ". Врагов: ", count_to_spawn)
	
	is_wave_spawning = true
	
	# Цикл создания врагов с задержкой
	for i in range(count_to_spawn):
		spawn_enemy()
		# Ждем 1 секунду перед следующим врагом (await)
		await get_tree().create_timer(1.0).timeout
	
	is_wave_spawning = false
	
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void: #РОМА
	get_tree().paused = false # РОМА
	get_tree().reload_current_scene() # РОМА
