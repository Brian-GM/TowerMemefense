extends Control

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var all_towers_unlocked = DataController.database.select_rows("towers", "unlocked == true", ["sprite"])[0]["sprite"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(all_towers_unlocked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
