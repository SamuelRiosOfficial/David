extends Control
const OPTIONS = ["INICIAR EL JUEGO", "INSTRUCCIONES", "CONFIGURACIONES", "HOPE MEDIA CHIAPAS"]
var selected := 0
var items: Array[Label] = []
var info: Label
func _ready():
	if ResourceLoader.exists("res://assets/video/menu_background.ogv"):
		var v=VideoStreamPlayer.new()
		v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		v.expand=true
		v.stream=load("res://assets/video/menu_background.ogv")
		v.autoplay=true
		add_child(v)
	else:
		var bg=ColorRect.new()
		bg.color=Color("#1c2929")
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(bg)
	var shade=ColorRect.new()
	shade.color=Color(0.02,0.04,0.04,0.35)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var root=VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.alignment=BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override("separation",18)
	add_child(root)
	for pair in [["DAVID",112],["El pastor, el rey, el amado de Dios",25]]:
		var l=Label.new()
		l.text=pair[0]
		l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_font_size_override("font_size",pair[1])
		l.add_theme_color_override("font_color",Color("#f0e6cf"))
		root.add_child(l)
	var gap=Control.new()
	gap.custom_minimum_size.y=38
	root.add_child(gap)
	for i in OPTIONS.size():
		var l=Label.new()
		l.text=OPTIONS[i]
		l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		l.custom_minimum_size=Vector2(560,48)
		l.mouse_filter=Control.MOUSE_FILTER_STOP
		l.gui_input.connect(_item_input.bind(i))
		root.add_child(l)
		items.append(l)
	info=Label.new()
	info.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	info.add_theme_font_size_override("font_size",18)
	root.add_child(info)
	_update()
func _unhandled_input(e):
	if e.is_action_pressed("ui_down"): selected=(selected+1)%items.size(); _update()
	elif e.is_action_pressed("ui_up"): selected=(selected-1+items.size())%items.size(); _update()
	elif e.is_action_pressed("ui_accept"): _activate()
func _item_input(e,i):
	if e is InputEventMouseMotion: selected=i; _update()
	elif e is InputEventMouseButton and e.pressed: selected=i; _update(); _activate()
func _update():
	for i in items.size():
		items[i].add_theme_font_size_override("font_size",31 if i==selected else 27)
		items[i].add_theme_color_override("font_color",Color("#fff1c7") if i==selected else Color("#d8d0c1"))
		items[i].modulate=Color(1,0.84,0.48,1) if i==selected else Color(0.82,0.82,0.78,0.82)
func _activate():
	match selected:
		0: get_tree().change_scene_to_file("res://scenes/levels/level_01.tscn")
		1: info.text="Camina, salta, agáchate y protege a las cinco ovejas con tu honda."
		2: info.text="Juego horizontal · controles táctiles · sonido del dispositivo."
		3: OS.shell_open("https://hopemedia.umch.org.mx/")
