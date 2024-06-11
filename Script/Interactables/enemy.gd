extends CharacterBody2D
var speed=1

func _physics_process(delta):
	position.x+=speed
	if position.x<=256:
		speed+=1
		$Sprite2D.scale.x=1
	if position.x>=430:
		speed-=1
		$Sprite2D.scale.x=-1
func _hit(body):
	if body.name=='Player':
		player_data.life-=1

