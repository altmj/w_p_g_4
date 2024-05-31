@tool
extends ColorRect

signal btn_pressed
signal btn_released

@export var text : String = ""
@export var debug_texture : bool = true
@export var set_font_size : int = 25

var trans_blue = Color8(0, 255, 255, 25)
var fully_transparent = Color8(0, 255, 255, 0)

@onready var label = $ButtonLabel
@onready var touch = $ButtonTouch
@onready var touch_shape = touch.get_shape()
@onready var touch_texture = touch.get_texture_normal()
@onready var touch_texture_gradient = touch_texture.get_gradient()

func button_setup():
	label.text = text
	label.set("theme_override_font_sizes/font_size", set_font_size)
	#label.font_size = set_font_size
	
	if touch_shape:
		touch_shape.set_size(size)
	if touch_texture:
		touch_texture.set_width(size[0])
		touch_texture.set_height(size[1])
		
	if debug_texture:
		touch_texture_gradient.set_colors(PackedColorArray([trans_blue, trans_blue]))
		touch.set_shape_visible(true)
	else:
		touch_texture_gradient.set_colors(PackedColorArray([fully_transparent, fully_transparent]))
		touch.set_shape_visible(false)

func _ready():
	touch.set_shape(RectangleShape2D.new())
	touch_shape = touch.get_shape()
	touch_shape.set_size(size)
	
	touch.set_texture_normal(GradientTexture2D.new())
	touch_texture = touch.get_texture_normal()
	touch_texture.set_width(size[0])
	touch_texture.set_height(size[1])
	touch_texture.set_gradient(Gradient.new())
	touch_texture_gradient = touch_texture.get_gradient()
	touch_texture_gradient.set_colors(PackedColorArray([trans_blue, trans_blue]))
		
	if not Engine.is_editor_hint():
		button_setup()
		#print(str(touch_shape.get_size()))
		#print(str(touch_texture.get_width()))
		#print(str(touch_texture.get_width()))
		
func _process(_delta):
	if Engine.is_editor_hint():
		if not touch_shape:
			touch.get_shape()
		if not touch_texture:
			touch.get_texture_normal()
		button_setup()

func _on_button_touch_pressed():
	btn_pressed.emit()

func _on_button_touch_released():
	btn_released.emit()
