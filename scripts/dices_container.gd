extends Panel

@onready var dice_6_sided: AnimatedSprite2D = $Dice6Sided
@onready var dice_4_sided: AnimatedSprite2D = $Dice4Sided


func _ready():
	pass
	
	
	


func _on_roll_button_pressed() -> void:
	var val6 = dice_6_sided.throw()
	var val4 = dice_4_sided.throw()
	
	dice_6_sided.roll(val6)
	dice_4_sided.roll(val4)
