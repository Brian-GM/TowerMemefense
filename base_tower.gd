extends StaticBody2D

@onready var bullet = preload("res://base_bala.tscn")
@onready var shoot_timer: Timer = $ShootCooldown
var shoot_cooldown: int = 2
var ready_to_shoot: bool = true

var currTargets: Array[Node2D] = []
var curr: Node2D = null 

func _process(delta: float) -> void:
	actualizar_objetivo()  # Siempre buscar al enemigo más avanzado
	
	if is_instance_valid(curr):
		look_at(curr.global_position) 
		
		if ready_to_shoot:
			shoot(curr)
			ready_to_shoot = false			
			shoot_timer.start(shoot_cooldown)

func _on_alcance_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		currTargets.append(body) 
		actualizar_objetivo()

func _on_alcance_ataque_body_exited(body: Node2D) -> void:
	if body in currTargets:
		currTargets.erase(body)
		actualizar_objetivo()

func actualizar_objetivo() -> void:
	if currTargets.is_empty():
		curr = null
	else:
		# Ordenar los enemigos por su progreso en el camino
		currTargets.sort_custom(func(a, b): return a.get_progress() > b.get_progress())  
		curr = currTargets[0]  # Elegir el enemigo más avanzado

func shoot(target: Node2D) -> void:
	if not is_instance_valid(target):
		return  

	var new_bullet = bullet.instantiate()
	get_parent().add_child(new_bullet)

	new_bullet.global_position = global_position  # Posicionar la bala en la torre
	new_bullet.target = target  # Asignar el objetivo

func _on_shoot_cooldown_timeout() -> void:
	ready_to_shoot = true
