class_name LocationSprite extends Sprite2D


@export var players = []
@export var index = 0
@onready var index_label: Label = $IndexLabel
@onready var location_label: Label = $LocationLabel


func set_location(terrain: Texture2D, lbl: String, ind: int):
	index = ind
	self.texture = terrain
	index_label.text = str(index)
	location_label.text = lbl
