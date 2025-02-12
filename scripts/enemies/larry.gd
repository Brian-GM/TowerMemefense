extends BaseEnemy


var speed = 50.0
var health = 50
var gold = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	SPEED = speed
	HEALTH = health
	GOLD = gold
	animated_sprite_2d.play("default")


func  _process(delta: float) -> void:
	progressive_move(delta)
	check_health()
	
