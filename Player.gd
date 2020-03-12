# Much of the code is referenced from youtuber UmaiPixel's "GoDot 3 - Platformer Tutorial" videos.
# I did not copy and paste anything.
extends KinematicBody2D

onready var sprite = get_node("AnimatedSprite")

const SPEED = 100
const GRAVITY = 9.81
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)
const BULLET = preload("res://Pewpew.tscn")

var velocity = Vector2()
var anim = "idle"
var on_ground = true
var attacking = false


func _physics_process(_delta):
	#moving left and right, jumping, gravity
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		if sign($Position2D.position.x) < 0:
			$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		if sign($Position2D.position.x) > 0:
			$Position2D.position.x *= -1
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		if on_ground == true:
			velocity.y = JUMP_POWER
			on_ground = false
	#player attack
	if Input.is_action_just_pressed("ui_focus_next"): #press Tab
		var bullet = BULLET.instance()
		if sign($Position2D.position.x) > 0:
			bullet.set_bullet_direction(1)
		else:
			bullet.set_bullet_direction(-1)
		get_parent().add_child(bullet)
		bullet.position = $Position2D.global_position
	
	velocity.y +=  GRAVITY
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false

	velocity = move_and_slide(velocity, FLOOR)

	#sprite animations~
	if velocity.x == 0:
		if Input.is_action_pressed("ui_focus_next"):
			anim = "attack"
		else:
			anim = "idle"
	else:
		if Input.is_action_pressed("ui_focus_next"):
			anim = "attack"
		else:
			anim = "move"
	if velocity.x > 0:
		sprite.set_flip_h(false)
	elif velocity.x < 0:
		sprite.set_flip_h(true)
	sprite.play(anim)
	
