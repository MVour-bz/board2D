class_name PlayerHud extends Panel

@onready var player_name: Label = $PlayerName
@onready var player_scpecies: Label = $PlayerScpecies
@onready var player_goal: Label = $PlayerGoal
@onready var player_ability: Label = $PlayerAbility
@onready var player_health: Label = $Panel/PlayerHealth
@onready var player_damage: Label = $Panel/PlayerDamage
@onready var animation_player: AnimationPlayer = $ToggleHudButton/AnimationPlayer
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite

func _ready():
	pass


func init(pl_name, species, goal, ability, health, damage):
	player_name.text = pl_name
	player_scpecies.text = species
	player_goal.text = goal
	player_ability.text = ability
	player_health.text = str(health)
	player_damage.text = str(damage)
	
	if species == "vampire":
		character_sprite.play("vampire")
	elif species == "warewolf":
		character_sprite.play("warewolf")
	


func _on_toggle_hud_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("ToggleHud")
	else:
		animation_player.play_backwards("ToggleHud")
