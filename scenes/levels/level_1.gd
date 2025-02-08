extends Node2D

@onready var enemies = {
	"larry": preload("res://scenes/enemies/larry.tscn"),
	#level2: preload(""),
	#level3: preload(""),
	#level4: preload(""),
	#level5: preload("")
}

func _ready() -> void:
	pass


func _on_enemies_spawn_timeout() -> void:

	# Crear un nuevo PathFollow2D para cada enemigo
	var new_path_follow = PathFollow2D.new()
	$Path2D.add_child(new_path_follow)
	
	# Instanciar enemigo y asignarlo al nuevo PathFollow2D
	var larry = enemies.larry.instantiate()
	new_path_follow.add_child(larry)
