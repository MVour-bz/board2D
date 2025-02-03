class_name QuestionMarkSprite extends Control

@onready var label: Label = $Panel/Panel/Label
@onready var avatar_txt: TextureRect = $Panel/AvatarTxt
@onready var q_mark: TextureRect = $Panel/QMark
@onready var panel: Panel = $Panel

var pl_id = ""

func _ready():
	q_mark.show()
	avatar_txt.hide()
	#if Global.active_player

func init(player):
	if player.pawn:
		if player.pawn != "":
			use_texture(player.pawn)
			Global.pawns[player.pawn].available = false
	if player.name:
		if player.name != "":
			set_sprite_name(player.name)
	pl_id = player.id
	if GameState.active_player.id == player.id:
		var themeBox : StyleBoxFlat = StyleBoxFlat.new()
		themeBox.border_color = Color("#e73da7")
		themeBox.bg_color = Color("#999a9300")
		themeBox.set_border_width_all(5)
		themeBox.border_blend = true
		panel.add_theme_stylebox_override("panel", themeBox)
		#panel.theme_override_styles["panel"] = themeBox
		#cccccc
	

func use_texture(color : String):
	q_mark.hide()
	avatar_txt.show()
	avatar_txt.texture = Global.pawns[color].sprite
	
	
func set_sprite_name(name : String):
	label.text = name
	
