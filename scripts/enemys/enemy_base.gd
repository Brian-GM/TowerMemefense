extends CharacterBody2D

class_name BaseEnemy

var speed = 200.0

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	progressive_move(delta)

func progressive_move(delta:float) -> void:
	var path_follow = get_parent()
	path_follow.set_progress(path_follow.get_progress() + speed * delta)
	if path_follow.get_progress_ratio() == 1:
		queue_free()
