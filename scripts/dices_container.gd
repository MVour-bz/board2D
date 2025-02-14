class_name DiceManager extends Panel

@onready var dice_6_sided: AnimatedSprite2D = $Dice6Sided
@onready var dice_4_sided: AnimatedSprite2D = $Dice4Sided
@onready var game_manager: GameManager = $"../GameManager"


func _ready():
	pass


func _on_roll_button_pressed() -> void:
	game_manager.roll_request.rpc_id(1, multiplayer.get_unique_id())

@rpc("any_peer", "call_local")
func roll_dices(val6, val4):
	dice_6_sided.roll(val6)
	dice_4_sided.roll(val4)
	
func throw_dices() -> Dictionary:
	var val6 = dice_6_sided.throw()
	var val4 = dice_4_sided.throw()
	
	#dice_6_sided.roll(val6)
	#dice_4_sided.roll(val4)
	return {"val6": val6, "val4": val4}
