extends Node2D
const PLAYER=preload("res://scripts/characters/david.gd")
const SHEEP=preload("res://scripts/characters/sheep.gd")
const ENEMY=preload("res://scripts/characters/enemy.gd")
var david:DavidPlayer
var flock:Array[FollowSheep]=[]
var hp:Label
var count:Label
const FLOOR_Y=760.0
func _ready():
	_world()
	david=PLAYER.new()
	david.position=Vector2(260,FLOOR_Y-60)
	add_child(david)
	var cam=Camera2D.new()
	cam.position_smoothing_enabled=true
	cam.position_smoothing_speed=6
	cam.limit_left=0
	cam.limit_right=6400
	cam.limit_bottom=900
	david.add_child(cam)
	cam.make_current()
	david.health_changed.connect(_health)
	for i in 5:
		var s:FollowSheep=SHEEP.new()
		s.slot=i
		s.shepherd=david
		s.position=david.position+Vector2(-110-i*54,0)
		add_child(s)
		flock.append(s)
	_spawn_enemy("lion",2250,230,2)
	_spawn_enemy("bear",4300,135,4)
	_hud()
	_touch()
func _world():
	var sky=ColorRect.new()
	sky.color=Color("#81939a")
	sky.position=Vector2(-1000,-1200)
	sky.size=Vector2(9000,2200)
	add_child(sky)
	var hills=Polygon2D.new()
	hills.polygon=PackedVector2Array([Vector2(-500,620),Vector2(250,260),Vector2(700,570),Vector2(1300,230),Vector2(1850,600),Vector2(2450,290),Vector2(3200,610),Vector2(3900,270),Vector2(4700,650),Vector2(5500,280),Vector2(6500,650),Vector2(6500,1100),Vector2(-500,1100)])
	hills.color=Color("#60756d")
	add_child(hills)
	var ground=StaticBody2D.new()
	ground.position=Vector2(3000,FLOOR_Y)
	var cs=CollisionShape2D.new()
	var rect=RectangleShape2D.new()
	rect.size=Vector2(7200,100)
	cs.shape=rect
	ground.add_child(cs)
	var art=Polygon2D.new()
	art.polygon=PackedVector2Array([Vector2(-3600,-45),Vector2(3600,-45),Vector2(3600,120),Vector2(-3600,120)])
	art.color=Color("#596346")
	ground.add_child(art)
	add_child(ground)
func _spawn_enemy(kind,x,spd,h):
	var e:WildEnemy=ENEMY.new()
	e.kind=kind
	e.position=Vector2(x,FLOOR_Y-65)
	e.speed=spd
	e.health=h
	e.target=david
	add_child(e)
func _hud():
	var layer=CanvasLayer.new()
	add_child(layer)
	var row=HBoxContainer.new()
	row.position=Vector2(36,24)
	row.add_theme_constant_override("separation",34)
	layer.add_child(row)
	hp=Label.new()
	hp.text="♥ ♥ ♥ ♥ ♥"
	hp.add_theme_font_size_override("font_size",34)
	hp.add_theme_color_override("font_color",Color("#d94d43"))
	row.add_child(hp)
	count=Label.new()
	count.text="OVEJAS  5 / 5"
	count.add_theme_font_size_override("font_size",27)
	count.add_theme_color_override("font_color",Color("#f1e8d7"))
	row.add_child(count)
func _touch():
	var layer=CanvasLayer.new()
	add_child(layer)
	_btn(layer,"◀",Vector2(54,850),"left")
	_btn(layer,"▶",Vector2(166,850),"right")
	_btn(layer,"▲",Vector2(110,735),"jump")
	_btn(layer,"▼",Vector2(110,965),"crouch")
	_btn(layer,"SALTAR",Vector2(1580,850),"jump",Vector2(140,76))
	_btn(layer,"HONDA",Vector2(1740,850),"sling",Vector2(140,76))
	_btn(layer,"SILBAR",Vector2(1660,945),"whistle",Vector2(140,64))
func _btn(layer,caption,pos,action,size_value=Vector2(92,92)):
	var b=Button.new()
	b.text=caption
	b.position=pos
	b.size=size_value
	b.modulate=Color(1,1,1,0.78)
	b.add_theme_font_size_override("font_size",20)
	var style=StyleBoxFlat.new()
	style.bg_color=Color(0.08,0.11,0.11,0.42)
	style.border_color=Color(0.9,0.82,0.66,0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(24)
	b.add_theme_stylebox_override("normal",style)
	layer.add_child(b)
	b.button_down.connect(_touch_action.bind(action,true))
	b.button_up.connect(_touch_action.bind(action,false))
func _touch_action(action,pressed):
	if action=="whistle":
		if pressed:
			for s in flock: s.fear=3.0
	else: david.set_touch(action,pressed)
func _health(value):
	var hearts=PackedStringArray()
	for i in 5: hearts.append("♥" if i<value else "♡")
	hp.text=" ".join(hearts)
func _process(_dt):
	var alive=0
	for s in flock:
		if is_instance_valid(s): alive+=1
	count.text="OVEJAS  %d / 5"%alive
