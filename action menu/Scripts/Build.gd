extends TextureButton

func _ready():
	
	var button = Button.new()
	button.add_theme_color_override("TextureButton", Color(1, 1, 1, 1))
	button.text = "Build"
	button.set_text_alignment(1)
	button.pressed.connect(self._button_pressed)
	add_child(button)
	button.add_theme_color_override("font_hover_color", Color(1, 0.5, 0))
	button.add_theme_color_override("font_color", Color(1, 0.5, 0))
	button.add_theme_color_override("icon_normal_color", Color(0.980392, 0.921569, 0.843137, 1))
	button.add_theme_color_override("icon_hover_color", Color(0.980392, 0.921569, 0.843137, 1))
	button.add_theme_font_size_override("font_size", 300)
	

func _button_pressed():
	print("Hello world!")
