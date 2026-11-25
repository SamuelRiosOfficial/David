extends Control

const GAME_TITLE := "DAVID"
const GAME_SUBTITLE := "El pastor, el rey, el amado de Dios"

func _ready() -> void:
	_build_menu()

func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color("#172b2b")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var content := VBoxContainer.new()
	content.custom_minimum_size = Vector2(560, 0)
	content.add_theme_constant_override("separation", 22)
	center.add_child(content)

	var title := Label.new()
	title.text = GAME_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 104)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = GAME_SUBTITLE
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 25)
	content.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size.y = 35
	content.add_child(spacer)

	for option in ["Iniciar el juego", "Instrucciones", "Configuraciones", "Hope Media Chiapas"]:
		var button := Button.new()
		button.text = option
		button.custom_minimum_size = Vector2(420, 58)
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.add_theme_font_size_override("font_size", 23)
		content.add_child(button)
