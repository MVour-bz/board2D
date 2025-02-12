class_name GameMap extends TileMapLayer


@onready var location_scn : PackedScene = preload("res://scenes/location_sprite.tscn")

@onready var positions = {
	"position_1": $Position1,
	"position_2": $Position2,
	"position_3": $Position3,
	"position_4": $Position4,
	"position_5": $Position5,
	"position_6": $Position6,
}

@onready var locations = {
	"old_chappel": preload("res://assets/background/chappel2.png"),
	"cabbin": preload("res://assets/background/chappel2.png"),
	"cemetary": preload("res://assets/background/chappel2.png"),
	"fountain": preload("res://assets/background/chappel2.png"),
	"stone_circle": preload("res://assets/background/chappel2.png"),
	"forest": preload("res://assets/background/chappel2.png")
}

func locations_spawn():
	var index = 0
	for loc in GameState.deck["locations"]:
		var new_loc : LocationSprite = location_scn.instantiate()
		self.add_child(new_loc)
		new_loc.set_location(locations[loc.name], loc.label, index+1)
		new_loc.position =  positions["position_" + str(index+1)].position
		index += 1
