extends Node

class_name Factory

func create_object(enemy: String) -> Node:
	var instance = null
	match enemy:
		"enemy_1":
			instance = preload("res://scenes/enemys/enemy1.tscn").instantiate()
		_:
			print("Tipo de objeto no reconocido")
	if instance != null:
		print("spawn")
		print(instance)
		instance.position = Vector2(-12, -28)
		instance.z_index = 1
		var animated_sprite = instance.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("default")
		return instance
	return null
