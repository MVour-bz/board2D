class_name PlayerSlotInfo extends Button

@export var player_sitting = null

@onready var name_label: Label = $NameLabel
@onready var player_pawn: Sprite2D = $PlayerPawn
@onready var damage: Label = $DamageLabel/Damage
@onready var species: Label = $SpeciesLabel/Species



func _ready():
	SignalBus.begin_turn.connect(_on_begin)
	SignalBus.end_turn.connect(_on_end)

func sit(player):
	name_label.text = player.name
	player_pawn.texture = Global.pawns[player.pawn].sprite
	damage.text = str(player.dmg)
	species.text = player.character.species if not player.hidden else (player.character.species + ("\n (Hidden)") if GameState.active_player.id == player.id else "?????")
	player_sitting = player

func _on_begin(pl_id):
	if player_sitting.id == pl_id:
		self.grab_focus()
		
func _on_end(pl_id):
	if player_sitting.id == pl_id:
		self.release_focus()
	
