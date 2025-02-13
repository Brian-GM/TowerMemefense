extends Control

var database : SQLite

var towers = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"rarity_id": {"data_type":"int", "foreign_key": "rarity.id"},
	"base_damage": {"data_type":"int"},
	"level": {"data_type":"int"},
	"unlocked": {"data_type":"bool"},
	"scene":{"data_type":"text"}
}

var rarity = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"drop_rate": {"data_type":"float"},
	"damage_multiplier": {"data_type":"int"}
}

var data_user = { 
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"level_account": {"data_type":"int"},
	"gold": {"data_type":"long"},
	"cuicuicoins": {"data_type":"long"},
	"cuicuigems": {"data_type":"long"},
	"current_date":{"data_type":"text"},
	"last_date":{"data_type":"text"}

}

var dificulty = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"multiplicator_health": {"data_type":"float"},
	"multiplicator_movement_speed": {"data_type":"float"},
	"enemies_numbers": {"data_type":"float"},
	"multiplicator_gold": {"data_type":"float"},
	"numbers_waves":{"data_type":"int"}

}

var level = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"scene": {"data_type":"text"},
	"dificulty_id": {"data_type":"int", "foreign_key": "dificulty.id"},


}
var spots = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"tower_id": {"data_type":"int", "foreign_key": "towers.id"},
}

var main_scene = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"level_id": {"data_type":"int", "foreign_key": "level.id"},
	"wave": {"data_type":"int"},

}
func _ready():
	database = SQLite.new()
	database.foreign_keys = true
	database.path = "user://data.db"

	var is_new_db = not FileAccess.file_exists(database.path)

	database.open_db()

	if is_new_db:
		
		database.create_table("towers", towers)
		database.create_table("rarity", rarity)
		database.create_table("data_user", data_user)
		database.create_table("dificulty", dificulty)
		database.create_table("main_scene", main_scene)
		database.create_table("level", level)

		
		# Datos de usuario de ejemplo
		var user_data = {
			"name": "Jugador1",
			"level_account": 1,
			"gold": 0,
			"cuicuicoins": 50,
			"cuicuigems": 5,
			"current_date": Time.get_datetime_string_from_system(),
			"last_date": Time.get_datetime_string_from_system()
		}
		database.insert_rows("data_user", [user_data])

		# Datos de rareza de torres
		var rarity_data = [
			{"name": "Común", "drop_rate": 0.5, "damage_multiplier": 1},
			{"name": "Raro", "drop_rate": 0.3, "damage_multiplier": 2},
			{"name": "Épico", "drop_rate": 0.15, "damage_multiplier": 3},
			{"name": "Legendario", "drop_rate": 0.05, "damage_multiplier": 4},
			{"name": "God", "drop_rate": 0.005, "damage_multiplier": 5}

			
		]
		database.insert_rows("rarity", rarity_data)

		# Datos de torres de ejemplo
		var towers_data = [
			{"name": "BaseTower", "rarity_id": 1, "base_damage": 10, "level": 1, "unlocked": true,"sprite":"res://assets/sprites/characters/base.png"},
			{"name": "Torre de cañón", "rarity_id": 2, "base_damage": 20, "level": 1, "unlocked": false,"sprite":"res://assets/sprites/characters/"},

		]
		database.insert_rows("towers", towers_data)

		# Datos de dificultad de ejemplo
		var dificulty_data = [
			{"name": "Fácil", "multiplicator_health": 1.0, "multiplicator_movement_speed": 1.0, "enemies_numbers": 10.0, "multiplicator_gold": 1.0, "numbers_waves": 25},
			{"name": "Normal", "multiplicator_health": 2.0, "multiplicator_movement_speed": 1.5, "enemies_numbers": 20.0, "multiplicator_gold": 2.0, "numbers_waves": 50},
			{"name": "Difícil", "multiplicator_health": 3.0, "multiplicator_movement_speed": 2.0, "enemies_numbers": 30.0, "multiplicator_gold": 3.0, "numbers_waves": 75},
			{"name": "Imposible", "multiplicator_health": 4.0, "multiplicator_movement_speed": 2.5, "enemies_numbers": 40.0, "multiplicator_gold": 4.0, "numbers_waves": 100},
			{"name": "Infinito", "multiplicator_health": 5.0, "multiplicator_movement_speed": 3.0, "enemies_numbers": 50.0, "multiplicator_gold": 5.0, "numbers_waves": 99999999999}

		]
		database.insert_rows("dificulty", dificulty_data)

		# Datos de niveles de ejemplo
		var levels_data = [
			{"name": "Bosque Oscuro", "scene": "res://scenes/bosque.tscn", "dificulty_id": 1},
			{"name": "Desierto Ardiente", "scene": "res://scenes/desierto.tscn", "dificulty_id": 2},
			{"name": "Castillo Maldito", "scene": "res://scenes/castillo.tscn", "dificulty_id": 3}
		]
		database.insert_rows("level", levels_data)

		# Datos de posiciones de torres en niveles (spots)
		var spots_data = [
			{"tower_id": 1},
			{"tower_id": 2},
			{"tower_id": 3},
			{"tower_id": 4}
		]
		database.insert_rows("spots", spots_data)

		var main_scene_data = {"level_id": 1, "wave": 1}
		database.insert_rows("main_scene", [main_scene_data])


func update_coins(gold_delta: int = 0, cuicuicoins_delta: int = 0, cuicuigems_delta: int = 0) -> void:
	# Obtener valores actuales de la base de datos
	var result = database.select_rows("data_user", "1", ["gold", "cuicuicoins", "cuicuigems"])
	
	if result.size() > 0:
		var current_gold = result[0]["gold"]
		var current_cuicuicoins = result[0]["cuicuicoins"]
		var current_cuicuigems = result[0]["cuicuigems"]
		
		# Sumar los valores nuevos
		var new_gold = current_gold + gold_delta
		var new_cuicuicoins = current_cuicuicoins + cuicuicoins_delta
		var new_cuicuigems = current_cuicuigems + cuicuigems_delta

		# Guardar en la base de datos
		var data = {
			"gold": new_gold,
			"cuicuicoins": new_cuicuicoins,
			"cuicuigems": new_cuicuigems
		}
		var conditions = "id = 1"
		database.update_rows("data_user", conditions, data)
		print("Monedas actualizadas: Oro:", new_gold, "Cuicuicoins:", new_cuicuicoins, "Cuicuigems:", new_cuicuigems)
	else:
		print("No se encontró registro en la base de datos. Creando uno nuevo...")
		var data = {
			"id": 1,
			"gold": gold_delta,
			"cuicuicoins": cuicuicoins_delta,
			"cuicuigems": cuicuigems_delta
		}
		database.insert_row("data_user", data)
		print("Nuevo registro creado en la base de datos.")

func update_wave(wave_delta: int = 1) -> void:
	# Obtener el nivel actual en la base de datos
	var result = database.select_rows("main_scene", "1", ["wave"])
	
	if result.size() > 0:
		var current_wave = result[0]["wave"]
		
		# Sumar el delta a la ola actual
		var new_wave =  wave_delta
		
		# Guardar en la base de datos
		var data = { "wave": new_wave }
		var conditions = "level_id = 1"
		database.update_rows("main_scene", conditions, data)
		print("Ola actualizada a:", new_wave)
	else:
		print("No se encontró el nivel en la base de datos. Creando un nuevo registro...")
		var data = {
			"wave": wave_delta
		}
		database.insert_row("main_scene", data)
		print("Nuevo registro creado para el nivel main con wave:", wave_delta)
