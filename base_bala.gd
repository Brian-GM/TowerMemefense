extends CharacterBody2D

@export var speed: float = 50  # Velocidad de la bala
var target: Node2D = null  # Enemigo a seguir
var damage: int = 100

func _process(delta: float) -> void:
	if is_instance_valid(target):
		look_at(target.global_position) 
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta 
	else:
		queue_free()  




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(self.damage)
		queue_free()
