extends CharacterBody2D
var speed=1
var player_inattackzone=false
var health=1
var enemy_attack_cooldown=true;
func _physics_process(delta):
	position.x+=speed
	if position.x<=256:
		speed+=1
		$Sprite2D.scale.x=1
	if position.x>=430:
		speed-=1
		$Sprite2D.scale.x=-1
	deal_with_damage()
#func _hit(body):
	#if body.name=='Player':
		#player_data.life-=1

func enemy():
	pass




func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattackzone=true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattackzone=false

func deal_with_damage():
	if player_inattackzone==true && enemy_attack_cooldown==true:
		player_data.life-=1
		enemy_attack_cooldown=false
		$attack_cooldown.start()



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true
