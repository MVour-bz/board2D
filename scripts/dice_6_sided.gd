extends AnimatedSprite2D

@onready var roll_button: Button = $RollButton
@onready var dice_texture: TextureRect = $DiceTexture
@onready var dice_right_side: AnimatedSprite2D = $DiceRightSide
@onready var dice_bottom_side: AnimatedSprite2D = $DiceBottomSide

@export var roll_animation_frames = 15
@export var value = 1

var roll_sets : Array = [
	["1", "6"],
	["2", "5"],
	["4", "3"]
]
var roll_tween

func _ready():
	self.animation = "idle"
	#roll_tween = get_tree().create_tween()
	#self.animation.frame

func throw() -> int:
	## decide number
	return randi() % 6 + 1

func roll(target : int):
	await roll_animation()
	set_sides(target)
	
func roll_animation():
	var prev_top = 5
	var prev_right = 4
	var prev_bot = 1
	var frame_right
	var frame_bot
	for i in range(roll_animation_frames):
		var animated_frame = 5
		while animated_frame == prev_top:
			animated_frame = randi() % 6 + 1
			frame_bot = randi() % 6 + 1
			frame_right = randi() % 6 + 1
		self.animation = str(animated_frame)
		dice_bottom_side.animation = str(frame_bot)
		dice_right_side.animation = str(frame_right)
		await get_tree().process_frame
		#await self.animation_finished
	

func set_sides(target):
	var top = target
	var bottom
	var right
	
	if roll_sets[0].has(str(target)):
		bottom = roll_sets[2][randi() % 2]
		right = roll_sets[1][randi() % 2]
	elif roll_sets[1].has(str(target)):
		bottom = roll_sets[0][randi() % 2]
		right = roll_sets[2][randi() % 2]
	elif roll_sets[2].has(str(target)):
		bottom = roll_sets[0][randi() % 2]
		right = roll_sets[1][randi() % 2]
		
			
	self.animation = str(top)
	dice_bottom_side.animation = str(bottom)
	dice_right_side.animation = str(right)

func _on_roll_button_pressed() -> void:
	roll(throw())
