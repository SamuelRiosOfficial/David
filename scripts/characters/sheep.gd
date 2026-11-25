extends CharacterBody2D
class_name FollowSheep
var shepherd:Node2D
var slot=0
var fear=0.0
func _ready():
	var cs=CollisionShape2D.new()
	var capsule=CapsuleShape2D.new()
	capsule.radius=20
	capsule.height=60
	cs.shape=capsule
	cs.position.y=-10
	add_child(cs)
	var wool=Polygon2D.new()
	wool.polygon=PackedVector2Array([Vector2(-29,-23),Vector2(-18,-39),Vector2(9,-38),Vector2(29,-21),Vector2(31,4),Vector2(18,23),Vector2(-22,22),Vector2(-33,4)])
	wool.color=Color("#e8e1d3")
	add_child(wool)
	var head=Polygon2D.new()
	head.polygon=PackedVector2Array([Vector2(17,-28),Vector2(36,-24),Vector2(42,-8),Vector2(32,5),Vector2(17,-3)])
	head.color=Color("#8e7764")
	add_child(head)
func _physics_process(dt):
	if not is_instance_valid(shepherd): return
	fear=maxf(0,fear-dt)
	var target=shepherd.global_position+Vector2(-((slot%3)+1)*105,-(slot%2)*15)
	if fear>0: target=shepherd.global_position+Vector2(-25,-10)
	var d=global_position.distance_to(target)
	if d>34:
		var dir=global_position.direction_to(target)
		velocity.x=move_toward(velocity.x,dir.x*235,900*dt)
		if is_on_floor() and global_position.y>target.y+35: velocity.y=-420
	else: velocity.x=move_toward(velocity.x,0,1000*dt)
	velocity.y+=1500*dt
	move_and_slide()
