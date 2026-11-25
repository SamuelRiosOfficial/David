extends CharacterBody2D
class_name DavidPlayer
signal health_changed(value:int)
@export var speed=390.0
@export var jump_velocity=-760.0
var health=5
var facing=1
var fire_timer=0.0
var crouching=false
var touch={"left":false,"right":false,"jump":false,"crouch":false,"sling":false}
var sprite:Sprite2D
var anim_time=0.0
var anim="idle"
func _ready():
	var cs=CollisionShape2D.new()
	var cap=CapsuleShape2D.new()
	cap.radius=24
	cap.height=104
	cs.shape=cap
	cs.position.y=-52
	add_child(cs)
	sprite=Sprite2D.new()
	sprite.texture=load("res://assets/characters/david/david_atlas.png")
	sprite.hframes=4
	sprite.vframes=4
	sprite.position.y=-74
	sprite.scale=Vector2(1.12,1.12)
	add_child(sprite)
func _physics_process(dt):
	fire_timer=maxf(0,fire_timer-dt)
	var x=Input.get_axis("move_left","move_right")
	x+=float(touch.right)-float(touch.left)
	x=clampf(x,-1,1)
	if x!=0: facing=int(sign(x))
	velocity.x=move_toward(velocity.x,x*speed*(0.48 if crouching or touch.crouch else 1.0),1900*dt)
	if not is_on_floor(): velocity.y+=1900*dt
	if (Input.is_action_just_pressed("jump") or touch.jump) and is_on_floor():
		velocity.y=jump_velocity
		touch.jump=false
	crouching=Input.is_action_pressed("crouch") or touch.crouch
	if Input.is_action_just_pressed("sling") or touch.sling: _throw(); touch.sling=false
	move_and_slide()
	_animate(dt)
func _animate(dt):
	var next="idle"
	if not is_on_floor(): next="jump" if velocity.y<0 else "fall"
	elif crouching: next="crouch"
	elif absf(velocity.x)>25: next="run" if absf(velocity.x)>260 else "walk"
	elif fire_timer>0.12: next="attack"
	if next!=anim: anim=next; anim_time=0
	anim_time+=dt
	var seq={"idle":[0,1],"walk":[2,3,2,3],"run":[4,5],"crouch":[6,7],"jump":[8,9],"fall":[10,11],"attack":[12,13]}
	var frames=seq.get(anim,[0])
	sprite.frame=frames[int(anim_time*(18 if anim=="run" else 13))%frames.size()]
	sprite.flip_h=facing<0
func _throw():
	if fire_timer>0: return
	fire_timer=0.24
	var stone=Area2D.new()
	stone.set_script(load("res://scripts/gameplay/stone.gd"))
	stone.collision_layer=2
	stone.collision_mask=4
	var art=Polygon2D.new()
	art.polygon=PackedVector2Array([Vector2(-8,-5),Vector2(5,-7),Vector2(9,0),Vector2(4,6),Vector2(-7,5)])
	art.color=Color("#c8b39a")
	stone.add_child(art)
	var cs=CollisionShape2D.new()
	var circle=CircleShape2D.new()
	circle.radius=9
	cs.shape=circle
	stone.add_child(cs)
	get_tree().current_scene.add_child(stone)
	stone.global_position=global_position+Vector2(36*facing,-70)
	stone.set_meta("velocity",Vector2(1050*facing,-90))
	stone.set_meta("life",1.2)
func set_touch(action:String,pressed:bool):
	if touch.has(action): touch[action]=pressed
func take_damage(amount=1):
	health=maxi(0,health-amount)
	health_changed.emit(health)
