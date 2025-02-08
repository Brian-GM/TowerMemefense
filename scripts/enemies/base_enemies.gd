extends CharacterBody2D

class_name BaseEnemy

var SPEED = 0
var HEALTH = 0

@onready var path_2d: Path2D = $Path2D


func progressive_move(delta:float) -> void:
	#Coge la ruta del path y hace que se mueva por esta, cuando llega al final hacer un queue_free
	var path_follow = get_parent()
	path_follow.set_progress(path_follow.get_progress() + SPEED * delta)
	if path_follow.get_progress_ratio() == 1:
		queue_free()
		
func check_health() -> void:
	#Mira si la vida del enemigo es menor o igual que 0
	if HEALTH <= 0:
		get_parent().get_parent().queue_free() 
