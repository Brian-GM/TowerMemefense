extends CharacterBody2D

class_name BaseEnemy

var SPEED = 0
var HEALTH = 0

@onready var path_follow: PathFollow2D = get_parent() as PathFollow2D  # Accede al PathFollow2D

func progressive_move(delta: float) -> void:
	if path_follow:  # Verifica que el path_follow es válido
		path_follow.progress += SPEED * delta  # Avanza en la ruta

		if path_follow.progress_ratio >= 1.0:  # Si llega al final, se elimina
			queue_free()

func get_progress() -> float:
	return path_follow.progress_ratio if path_follow else 0.0  # Retorna el avance del enemigo

func check_health() -> void:
	if HEALTH <= 0:
		queue_free() 

func take_damage(damage):
	HEALTH -= damage
	check_health()
