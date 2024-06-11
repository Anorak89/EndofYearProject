extends CharacterBody2D



@onready var sfx_jump = $sfx_jump
@onready var sfx_sword = $sfx_sword
@onready var sfx_dash = $sfx_dash

var input 
@export var speed=100.0
@export var gravity=10
var dashYes=true
#variable for jumping
var jump_count=0
@export var max_jump=2
@export var jump_force=500


#About Dash
@export var dash_force=600


#everything related to state machine
var current_state = player_states.MOVE
enum player_states{MOVE, SWORD, DEAD, DASH}

# Called when the node enters the scene tree for the first time.
func _ready():
	$sword/sword_collider.disabled=true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_data.life<=0:
		current_state=player_states.DEAD
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.DEAD:
			dead()
		player_states.DASH:
			dash()
	
func movement(delta):
	input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	
	if input!=0:
		if input>0:
			velocity.x+=speed*delta
			velocity.x=clamp(speed,100.0,speed)
			$Sprite2D.scale.x=1
			$sword.position.x=19
			$anim.play("Walk")
		if input<0:
			velocity.x-=speed*delta
			velocity.x=clamp(-speed,100.0,-speed)
			$Sprite2D.scale.x=-1
			$sword.position.x=-19
			$anim.play("Walk")
	
	if(input==0):
		velocity.x=0
		$anim.play("Idle")
		
#CODE RELATED TO JUMPING
	if is_on_floor():
		jump_count=0
	if !is_on_floor():
		if velocity.y < 0:
			$anim.play("Jump")
		if velocity.y > 0:
			$anim.play("Fall")

	if Input.is_action_just_pressed("ui_accept")&& is_on_floor() && jump_count<max_jump:
		jump_count+=1
		velocity.y-=jump_force
		velocity.x=input
		sfx_jump.play()
	if !is_on_floor()&&Input.is_action_just_pressed("ui_accept")&&jump_count<max_jump:
		jump_count+=1
		velocity.y-=jump_force*1.2
		velocity.x=input
		sfx_jump.play()
	
	if !is_on_floor()&&Input.is_action_just_released("ui_accept")&&jump_count<max_jump:
		velocity.y=gravity
		velocity.x=input

	else:
		gravity_force()
	
	if Input.is_action_just_pressed("ui_sword"):
		current_state=player_states.SWORD
		sfx_sword.play()
	if Input.is_action_just_pressed("ui_dash"):
		current_state=player_states.DASH
		sfx_dash.play()
	
	
	gravity_force()
	move_and_slide()

func gravity_force():
	velocity.y+=gravity
func sword(delta):
	$anim.play("Sword")
	input_movement(delta)
	
func dash():
	if player_data.coin>0:
		player_data.coin-=1
		if velocity.x>0:
			velocity.x+=dash_force
			await get_tree().create_timer(0.1).timeout
			current_state=player_states.MOVE
		elif velocity.x<0:
			velocity.x-=dash_force
			await get_tree().create_timer(0.1).timeout
			current_state=player_states.MOVE
		else:
			if $Sprite2D.scale.x==1:
				velocity.x+=dash_force
				await get_tree().create_timer(0.1).timeout
				current_state=player_states.MOVE
			if $Sprite2D.scale.x==-1:
				velocity.x-=dash_force
				await get_tree().create_timer(0.1).timeout
				current_state=player_states.MOVE
	else:
		current_state=player_states.MOVE
		
	move_and_slide()
func dead():
	$anim.play("Dead")
	velocity.x=0 
	gravity_force()
	move_and_slide()
	await $anim.animation_finished
	player_data.life=4
	player_data.coin=0
	if get_tree():
		get_tree().reload_current_scene()

func input_movement(delta):
	input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	
	if input!=0:
		if input>0:
			velocity.x+=speed*delta
			velocity.x=clamp(speed,100.0,speed)
			$Sprite2D.scale.x=1
		if input<0:
			velocity.x-=speed*delta
			velocity.x=clamp(-speed,100.0,-speed)
			$Sprite2D.scale.x=-1
	if(input==0):
		velocity.x=0
	gravity_force()
	
	
	move_and_slide()
func hit():
	player_data.life -= 1


func reset_states():
	current_state=player_states.MOVE
	
