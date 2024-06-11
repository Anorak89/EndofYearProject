extends Node

class_name Damageable

@export var health:float =20
# Called when the node enters the scene tree for the first time.
func hit(damage:int):
	health-=damage
	
	if(health<=0):
		get_parent().queue_free()
