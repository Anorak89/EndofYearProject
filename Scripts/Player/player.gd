extends CharacterBody2D

var input
@export var speed = 100.0
@export var gravity = 10

# VARIABLE FOR JUMPING
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 500



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement(delta)

func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if(input != 0):
		$AnimationPlayer.play("Walk")
		if(input > 0):
			velocity.x += speed*delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
			
		if(input < 0):
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
			
	
	if(input == 0):
		velocity.x = 0
		$AnimationPlayer.play("Idle")
		
#Code Related to jumping
	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if velocity.y < 0:
			$AnimationPlayer.play("Jump")
		if velocity.y > 0:
			$AnimationPlayer.play("Fall")
			
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * 1.2
		velocity.x = input
	
	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	
	else:
		gravity_force()
	
	gravity_force()
	move_and_slide()

func gravity_force():
	velocity.y += gravity
