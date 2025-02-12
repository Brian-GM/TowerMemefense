extends Node2D

@onready var last_wave: int = DataController.database.select_rows("dificulty", "id == 1", ["numbers_waves"])[0]["numbers_waves"]
@onready var enemies_per_wave: int = DataController.database.select_rows("dificulty", "id == 1", ["enemies_numbers"])[0]["enemies_numbers"]
var living_enemies: int = 0
var spawn_interval: float = 1
var current_wave: int = 1


func _ready() -> void:
	pass

func start_wave(enemies: Array) -> void:
	living_enemies = enemies_per_wave
	print(living_enemies)
	if current_wave <= last_wave:
		print("Iniciando oleada ", current_wave)

		for i in range(enemies_per_wave):
			await get_tree().create_timer(spawn_interval).timeout  # Espera entre spawns

			# Seleccionar un enemigo aleatorio del vector
			var enemy_scene = load(enemies[randi() % enemies.size()])
			if not enemy_scene:
				print("Error: No se pudo cargar la escena del enemigo.")
				continue

			# Crear PathFollow2D
			var new_path_follow = PathFollow2D.new()
			new_path_follow.set_progress_ratio(0)  # Comienza al inicio del camino
			new_path_follow.loop = false
			
			var path_node = get_tree().current_scene.find_child("Path2D", true, false)
			path_node.add_child(new_path_follow)  # Agregar al Path2D

			# Instanciar enemigo
			var enemy = enemy_scene.instantiate()
			enemy.health *= DataController.database.select_rows("dificulty", "id == 1", ["multiplicator_health"])[0]["multiplicator_health"]
			enemy.speed *= DataController.database.select_rows("dificulty", "id == 1", ["multiplicator_movement_speed"])[0]["multiplicator_movement_speed"]
			enemy.gold *= DataController.database.select_rows("dificulty", "id == 1", ["multiplicator_gold"])[0]["multiplicator_gold"]
			enemy.set_meta("path_follow", new_path_follow)
			new_path_follow.add_child(enemy)	
			print("Enemigo ++")

			

		current_wave += 1
		
		
func check_end_wave(enemies):
	print("Enemigos vivos: " , living_enemies , " Enemigos totales: ",enemies_per_wave)
	if living_enemies <= 0:
		await get_tree().create_timer(5).timeout  # Espera entre oleadas
		start_wave(enemies) 
