extends CharacterBody2D  

var target  #la posición del objetivo.
var speed = 1000
var pathName = ""  
var bulletDamage:int  = 10

func _physics_process(delta: float) -> void: 
	var pathSpawnerNode = get_tree().get_root().get_node("Main/PathSpawner") 
	
	for i in pathSpawnerNode.get_child_count():  # Itera a través de todos los hijos de PathSpawner.
		if pathSpawnerNode.get_child(i).name == pathName:  # Comprueba si el nombre del hijo es igual al nombre del camino deseado.
			target = pathSpawnerNode.get_child(i).get_child(0).get_child(0).global_position  # Asigna la posición global del primer nieto del hijo al objetivo.
			
	velocity = pathSpawnerNode.direction_to(target) * speed  # Calcula la velocidad en la dirección del objetivo, multiplicada por la velocidad.
	
	look_at(target)  # Hace que el nodo mire hacia el objetivo.
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"): 
		body.health -= bulletDamage  
