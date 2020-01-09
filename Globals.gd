extends Node

#consts
const is_debug := true

#signals
signal signal_pain
const signal_pain_string := "signal_pain"
signal signal_update_ui
const signal_update_ui_string := "signal_update_ui"
signal signal_toggle_game_menu
const signal_toggle_game_menu_string := "signal_toggle_game_menu"
signal signal_toggle_main_menu
const signal_toggle_main_menu_string := "signal_toggle_main_menu"
signal signal_pause
const signal_pause_string := "signal_pause"
signal signal_resume
const signal_resume_string := "signal_resume"

#vars
var player


#funcs
func _input(event):
	if event.is_action_pressed("Game_Menu"):
		emit_signal(Globals.signal_toggle_game_menu_string)
	elif event.is_action_pressed("Main_Menu"):
		emit_signal("signal_toggle_main_menu")
	#db only
	elif not is_debug:
		return
	elif event.is_action_pressed("db_exit"):
		exit()
	elif event.is_action_pressed("db_restart"):
		restart()

func restart():
	get_tree().reload_current_scene()

func exit():
	get_tree().quit()

func pause():
	emit_signal(Globals.signal_pause_string)
	
func resume():
	emit_signal(Globals.signal_resume_string)
