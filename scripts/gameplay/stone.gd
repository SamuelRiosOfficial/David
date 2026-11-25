extends Area2D
var velocity=Vector2.ZERO
var life=1.2
func _ready():
	velocity=get_meta("velocity",Vector2.ZERO)
	life=get_meta("life",1.2)
	body_entered.connect(_hit)
func _physics_process(dt):
	life-=dt
	position+=velocity*dt
	velocity.y+=420*dt
	rotation+=8*dt
	if life<=0: queue_free()
func _hit(body):
	if body.has_method("take_hit"): body.take_hit(1)
	queue_free()
