class_name PlayerSlotInfo extends Button

@onready var name_label: Label = $NameLabel
@onready var player_pawn: Sprite2D = $PlayerPawn
@onready var damage: Label = $DamageLabel/Damage
@onready var species: Label = $SpeciesLabel/Species



func sit(player):
	name_label.text = player.name
	player_pawn.texture = Global.pawns[player.pawn].sprite
	damage.text = str(player.dmg)
	species.text = player.character.species if not player.hidden else (player.character.species + ("\n (Hidden)") if GameState.active_player.id == player.id else "?????")
