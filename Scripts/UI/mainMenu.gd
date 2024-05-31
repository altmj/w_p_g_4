extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() != "Android":
		var usable_screen_height = DisplayServer.screen_get_usable_rect().size.y
		var usable_screen_height_safe = 2 * usable_screen_height - DisplayServer.screen_get_size().y
		var base_viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
		if usable_screen_height_safe < base_viewport_height:
			var width_scaled = ProjectSettings.get_setting("display/window/size/viewport_width") * usable_screen_height_safe / base_viewport_height
			var window_x_pos = DisplayServer.window_get_position().x
			DisplayServer.window_set_size(Vector2i(width_scaled, usable_screen_height_safe))
			DisplayServer.window_set_position(Vector2i(window_x_pos, DisplayServer.screen_get_size().y - usable_screen_height))


#Main Menu
func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")

func _on_button_pengaturan_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/setelan.tscn")

func _on_talents_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Talents.tscn")

func _on_jurnal_antigen_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Jurnal Antigen.tscn")

func _on_battle_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

# Pengaturan

func _on_button_xx_pause_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")




#Pause
func _on_button_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/AreYouSure.tscn")
	
func _on_button_setting_pause_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/settingPause.tscn")

func _on_button_resume_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")

func _on_button_x_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Pause.tscn")


#Areyousure
func _on_button_no_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/Pause.tscn")


func _on_button_yes_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


#willdone
func _on_button_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func _on_button_mainmenu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func _on_scroll_container_scroll_started():
	print("Scrolling started!")


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/setelan.tscn")


func _on_sentuh_layar_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
