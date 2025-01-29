class_name QuestionMarkSprite extends Control

@onready var label: Label = $Label
@onready var avatar_txt: TextureRect = $AvatarTxt
@onready var q_mark: TextureRect = $QMark


func _ready():
	q_mark.show()
	avatar_txt.hide()

func use_texture(color : String):
	q_mark.hide()
	avatar_txt.show()
	avatar_txt.texture = Global.pawns[color].sprite
	
	
func set_sprite_name(name : String):
	label.text = name
