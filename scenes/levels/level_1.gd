extends Node2D


@onready var spot_1: TouchScreenButton = $TowerSpots/Spot1
@onready var spot_2: TouchScreenButton = $TowerSpots/Spot2
@onready var spot_3: TouchScreenButton = $TowerSpots/Spot3
@onready var spot_4: TouchScreenButton = $TowerSpots/Spot4
@onready var spot_5: TouchScreenButton = $TowerSpots/Spot5
@onready var spot_6: TouchScreenButton = $TowerSpots/Spot6
@onready var spot_7: TouchScreenButton = $TowerSpots/Spot7
@onready var spot_8: TouchScreenButton = $TowerSpots/Spot8
@onready var spot_9: TouchScreenButton = $TowerSpots/Spot9

@onready var tower_scene = preload("res://base_tower.tscn").instantiate()

# Diccionario que almacena la referencia de la torre en cada spot
var towers_spots = {
	"spot1": null, "spot2": null, "spot3": null, "spot4": null, 
	"spot5": null, "spot6": null, "spot7": null, "spot8": null, 
	"spot9": null, "spot10": null, "spot11": null, "spot12": null
}

var enemies = ["res://scenes/enemies/larry.tscn"]

func _ready() -> void:
	pass


func _on_spot_1_pressed() -> void:
	tower_scene.position = spot_1.position
	tower_scene.top_level = true
	spot_1.add_child(tower_scene)
	print("Tower placed at:", tower_scene.position)
