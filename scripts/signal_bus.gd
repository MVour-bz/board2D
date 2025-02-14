extends Node

#Test
signal _add_player

# Game Function signals
signal _exit_game
signal _new_game
signal _start_game
signal begin_turn
signal end_turn
signal _end_game

signal _set_character
signal _attach_deck
signal set_locations

## Avatar Creation signals (might include avatar movement or actions as well)
signal _avatar_reserved
signal _avatar_released
signal _avatar_created


# Navigation
signal _return_to_main_menu
signal _return_to_mulitplayer_menu
