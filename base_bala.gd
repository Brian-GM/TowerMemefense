extends CharacterBody2D

@export var speed: float = 300  # Velocidad de la bala
var target: Node2D = null  # Enemigo a seguir
var damage: int = 10

func _process(delta: float) -> void:
	if is_instance_valid(target):
		look_at(target.position) 
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta  # Mueve la bala en dirección al objetivo
	else:
		queue_free()  # Si el enemigo desaparece, eliminar la bala




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(self.damage)
		queue_free()
