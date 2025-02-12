extends Control

var database : SQLite

var towers = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"name": {"data_type":"text"},
	"rarity_id": {"data_type":"int", "foreign_key": "rarity.id"},
	"base_damage": {"data_type":"int"},
	"level": {"data_type":"int"},
	"unlocked": {"data_type":"bool"}
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
	"level_id": {"data_type":"int", "foreign_key": "level.id"},
	"tower_id": {"data_type":"int", "foreign_key": "tower.id"},

}
var main_scene = {
	"id": {"data_type":"int","primary_key":true,"not_null" : true,"auto_increment":true},
	"level_id": {"data_type":"int", "foreign_key": "level.id"},
	"wave": {"data_type":"int"},
	"spots_id": {"data_type":"int", "foreign_key": "spots.id"},


}
func _ready():
	database = SQLite.new()
	database.foreign_keys = true
	database.path = "user://data.db"

	var is_new_db = not FileAccess.file_exists(database.path)

	database.open_db()

	if is_new_db:
		# Crear tablas
		database.create_table("towers", towers)
		database.create_table("rarity", rarity)
		database.create_table("data_user", data_user)
		database.create_table("dificulty", dificulty)
		database.create_table("main_scene", main_scene)
		
		# Datos de usuario de ejemplo
	var user_data = {
		"name": "Jugador1",
		"level_account": 1,
		"gold": 1000,
		"cuicuicoins": 50,
		"cuicuigems": 5,
		"current_date": Time.get_datetime_string_from_system(),
		"last_date": Time.get_datetime_string_from_system()
	}
	database.insert_rows("data_user", [user_data])

	# Datos de rareza de torres
	var rarity_data = [
		{"name": "Común", "drop_rate": 0.5, "damage_multiplier": 1},
		{"name": "Raro", "drop_rate": 0.3, "damage_multiplier": 1.5},
		{"name": "Épico", "drop_rate": 0.15, "damage_multiplier": 2},
		{"name": "Legendario", "drop_rate": 0.05, "damage_multiplier": 3}
	]
	database.insert_rows("rarity", rarity_data)

	# Datos de torres de ejemplo
	var towers_data = [
		{"name": "Torre de flechas", "rarity_id": 1, "base_damage": 10, "level": 1, "unlocked": true},
		{"name": "Torre de cañón", "rarity_id": 2, "base_damage": 20, "level": 1, "unlocked": false},
		{"name": "Torre de mago", "rarity_id": 3, "base_damage": 35, "level": 1, "unlocked": false},
		{"name": "Torre de rayo", "rarity_id": 4, "base_damage": 50, "level": 1, "unlocked": false}
	]
	database.insert_rows("towers", towers_data)

	# Datos de dificultad de ejemplo
	var dificulty_data = [
		{"name": "Fácil", "multiplicator_health": 0.8, "multiplicator_movement_speed": 0.9, "enemies_numbers": 1.0, "multiplicator_gold": 1.0, "numbers_waves": 5},
		{"name": "Normal", "multiplicator_health": 1.0, "multiplicator_movement_speed": 1.0, "enemies_numbers": 1.2, "multiplicator_gold": 1.2, "numbers_waves": 7},
		{"name": "Difícil", "multiplicator_health": 1.5, "multiplicator_movement_speed": 1.1, "enemies_numbers": 1.5, "multiplicator_gold": 1.5, "numbers_waves": 10}
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
		{"level_id": 1, "tower_id": 1},
		{"level_id": 1, "tower_id": 2},
		{"level_id": 2, "tower_id": 3},
		{"level_id": 3, "tower_id": 4}
	]
	database.insert_rows("spots", spots_data)

	# Datos de la escena principal
	var main_scene_data = [
		{"level_id": 1, "wave": 1, "spots_id": 1},
		{"level_id": 2, "wave": 1, "spots_id": 2},
		{"level_id": 3, "wave": 1, "spots_id": 3}
	]
	database.insert_rows("main_scene", main_scene_data)


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

func update_wave(level_id: int, wave_delta: int = 1) -> void:
	# Obtener el nivel actual en la base de datos
	var result = database.select_rows("main_scene", "level_id = %d" % level_id, ["wave"])
	
	if result.size() > 0:
		var current_wave = result[0]["wave"]
		
		# Sumar el delta a la ola actual
		var new_wave = current_wave + wave_delta
		
		# Guardar en la base de datos
		var data = { "wave": new_wave }
		var conditions = "level_id = %d" % level_id
		database.update_rows("main_scene", conditions, data)
		print("Ola actualizada a:", new_wave)
	else:
		print("No se encontró el nivel en la base de datos. Creando un nuevo registro...")
		var data = {
			"level_id": level_id,
			"wave": wave_delta
		}
		database.insert_row("main_scene", data)
		print("Nuevo registro creado para el nivel", level_id, "con wave:", wave_delta)
