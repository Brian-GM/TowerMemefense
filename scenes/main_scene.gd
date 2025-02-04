extends Node2D
@onready var path = preload("res://scenes/levels/path_lvl1.tscn")

func _on_spawn_timer_timeout() -> void:
	var tempPath = path.instantiate()
	add_child(tempPath)
