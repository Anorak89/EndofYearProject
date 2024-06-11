extends PathFollow2D 
var current_state = enemy_state.WALK
enum enemy_state{WALK}

func movement():
	if progress_ratio >= 0.5:
		$Sprite2D.position.x=-1
		$anim.play("Walking")
	else:
		$Sprite2D.position.x=1
		$anim.play("Walking")
func _process(delta):
	match current_state:
		enemy_state.WALK:
			movement()

