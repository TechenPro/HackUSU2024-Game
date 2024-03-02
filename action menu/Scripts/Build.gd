extends TextureButton

func _ready():
	var button = Button.new()
	button.add_theme_color_override("TextureButton", Color(1, 1, 1, 1))
	button.text = "Build"
	button.pressed.connect(self._button_pressed)
	add_child(button)
	button.add_theme_color_override("font_hover_color", Color(1, 0.5, 0))
	button.add_theme_color_override("font_color", Color(1, 0.5, 0))
	button.add_theme_color_override("icon_normal_color", Color(0.980392, 0.921569, 0.843137, 1))
	button.add_theme_color_override("icon_hover_color", Color(0.980392, 0.921569, 0.843137, 1))
	button.add_theme_font_size_override("font_size", 300)
	

# Connect the signal from each unit to the _on_unit_selected function
	connect("unit_selected", _on_unit_selected())


func _button_pressed():
	print("Hello world!")

func _on_unit_selected():
	# Do something with the unit's info, such as updating the button's text or logic
	print("id")
