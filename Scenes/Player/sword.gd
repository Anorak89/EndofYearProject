extends Area2D
@export var damage: int =10

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
	print(body.name)
