extends CharacterBody2D
class_name enemy
var speed=1
static var player_inattackzone=false
static var health= 0.3
var enemy_attack_cooldown=true;

func _physics_process(delta):
	if(health<=0):
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/ending.tscn")
	if $Sprite2D.visible:
		position.x+=speed
		if position.x<=50:
			speed+=1
			$Sprite2D.scale.x=1
		if position.x>=650:
			speed-=1
			$Sprite2D.scale.x=-1
		deal_with_damage()
	
		#help()
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
		#print("Hi")
		enemy_attack_cooldown=false
		$attack_cooldown.start()
#func help():
	#if player.enemy_in_attackrange==true:
		#health-=1


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true
