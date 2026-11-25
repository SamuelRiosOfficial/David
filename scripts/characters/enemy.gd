extends CharacterBody2D
class_name WildEnemy
@export var kind="lion"
@export var speed=190.0
@export var health=2
var target:Node2D
var cooldown=0.0
func _ready():
	collision_layer=4
	var art=Polygon2D.new()
	art.polygon=PackedVector2Array([Vector2(-43,-13),Vector2(-27,-36),Vector2(5,-42),Vector2(35,-25),Vector2(48,-4),Vector2(32,13),Vector2(-33,13)])
	art.color=Color("#665044") if kind=="bear" else Color("#b17a42")
	add_child(art)
	var cs=CollisionShape2D.new()
	var cap=CapsuleShape2D.new()
	cap.radius=28
	cap.height=62
	cs.shape=cap
	cs.position.y=-30
	add_child(cs)
func _physics_process(dt):
	cooldown=maxf(0,cooldown-dt)
	if not is_instance_valid(target): return
	var dx=target.global_position.x-global_position.x
	velocity.x=signf(dx)*speed if absf(dx)>75 else 0
	velocity.y+=1500*dt
	move_and_slide()
	if absf(dx)<65 and cooldown<=0:
		cooldown=1.4
		if target.has_method("take_damage"): target.take_damage(1)
func take_hit(amount):
	health-=amount
	if health<=0: queue_free()
