extends Node2D
@onready var gold_label: Label = $Gold
@onready var cui_cui_coins_label: Label = $CuiCuiCoins
@onready var cui_cui_gems_label: Label = $CuiCuiGems
@onready var wave_n_: Label = $"WaveNº"

@onready var levels = {
	"level1": preload("res://scenes/levels/level_1.tscn"),
	#level2: preload(""),
	#level3: preload(""),
	#level4: preload(""),
	#level5: preload("")
}
var TowerSpots
@onready var SpotsDict = {}

@onready var level_scene = levels.level1.instantiate()
@onready var dificulty = DataController.dificulty

func _ready():
	add_child(level_scene)
	TowerSpots = find_child("TowerSpots",true,false)
	getTowerSpots()
	
	WaveController.start_wave(level_scene.enemies)
		
func _process(delta: float) -> void:
	gold_label.text = str(DataController.database.select_rows("data_user", "1", ["gold"])[0]["gold"])
	cui_cui_coins_label.text = str(DataController.database.select_rows("data_user", "1", ["cuicuicoins"])[0]["cuicuicoins"])
	cui_cui_gems_label.text = str(DataController.database.select_rows("data_user", "1", ["cuicuigems"])[0]["cuicuigems"])
	wave_n_.text = str(DataController.database.select_rows("main_scene", "1", ["wave"])[0]["wave"])
	WaveController.check_end_wave(level_scene.enemies)

func getTowerSpots() -> void:
	var index: int = 1
	for spot in TowerSpots.get_children():
		var key = "spot" + str(index)
		SpotsDict[key] = spot
		index += 1
		print("Stored:", key, "->", spot)
