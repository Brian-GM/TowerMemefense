extends StaticBody2D

@onready var bullet = preload("res://base_bala.tscn")

var bullet_damage = 10
var pathName  
var currTargets = []
var curr
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	if is_instance_valid(curr):
		self.look_at(curr.global_position)


func _on_tower_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		for i in currTargets:
			if i.is_in_group("Enemy"):
				tempArray.append(i)
		var currTarget = null
		
		for i in tempArray:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currTarget.get_progress():
					currTarget = i.get_node("../")
			curr = currTarget
			pathName = currTarget.get_parent().name
			
			var tempBullet = bullet.instantiate()
			tempBullet.pathName = pathName
			tempBullet.bullet_damage =  bullet_damage
			get_node("BulletContainer").add_child(tempBullet)
			tempBullet.global_position = $Aim.global_position



func _on_tower_body_exited(body: Node2D) -> void:
	currTargets = get_node("Tower").get_overlapping_bodies()
