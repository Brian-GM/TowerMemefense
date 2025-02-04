extends BaseEnemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func  _process(delta: float) -> void:
	progressive_move(delta)
