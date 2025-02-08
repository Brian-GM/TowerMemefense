extends BaseEnemy


const speed = 50.0
var health = 50
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	SPEED = speed
	HEALTH = health
	animated_sprite_2d.play("default")


func  _process(delta: float) -> void:
	progressive_move(delta)
	check_health()
	
