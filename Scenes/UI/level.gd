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



# Called every frame. 'delta' is the elapsed time since the previous frame.
