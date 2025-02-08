extends Node2D
@onready var levels = {
	"level1": preload("res://scenes/levels/level_1.tscn"),
	#level2: preload(""),
	#level3: preload(""),
	#level4: preload(""),
	#level5: preload("")
}

func _ready():
	var level_scene = levels.level1.instantiate()
	add_child(level_scene)
	print("Nivel 1 cargado")
