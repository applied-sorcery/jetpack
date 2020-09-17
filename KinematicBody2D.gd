extends KinematicBody2D

const ACCEL = 50
const FRICTION = 5
const MAX_JETFUEL = 6000
#const MAX_FLYING_SPD = 0
#const MAX_WALKING_SPD =0

var up = Vector2(0,-1)
var motion = Vector2()



var walking_speed = 500
var flying_speed = 700
var grav = 50
var jump_height = -500
var jetpack_is_on = true
var jetfuel = MAX_JETFUEL


onready var pbar = self.get_node("Camera2D/JetfuelBar")

 

	


func turn_jetpack_on():
	jetpack_is_on = true
	print("turning jetpack on")
	motion.y -= 500 
	jetfuel -= 5
	
	pass


func turn_jetpack_off():
	jetpack_is_on = false
	print("turning jetpack off")
	print("position:  ")
	print(position);
	pass



func _physics_process(delta):
	
	
# First, here are the "base" motion/controls  
#   - We'll start with horizontal motion/controls
	
	#print(jetfuel)  <-- use for debugging
	if !jetpack_is_on:
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x + ACCEL, walking_speed)
			$Sprite.flip_h = false
			$Sprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x - ACCEL, -walking_speed)
			$Sprite.flip_h = true
			$Sprite.play("Run")
		else:
				motion.x = 0
				$Sprite.play("Idle")
#   - Next we'll tackle "base" vertical motion/controls, so jumping and gravity:
		motion.y += grav
		if Input.is_action_just_pressed("ui_up"):
			if is_on_floor():
				motion.y += jump_height
#
	else: 
	
	#description:
	#  the controls when the jetpack is ON
	#  should implement getting close to ground but not walking on it, hovering above. 
		if jetfuel > 0:
			jetfuel -= 5
			# if I have click menu items, make the motion NOT affected by these clicks. commented out for now instead.
			#if Input.is_mouse_button_pressed(BUTTON_LEFT):
			#  motion = Vector2((get_local_mouse_position().x - $Sprite.position.x), (get_local_mouse_position().y - $Sprite.position.y)).normalized()*flying_speed
			
			if Input.is_action_pressed("ui_right"):
				motion.x = flying_speed
				$Sprite.flip_h = false
				$Sprite.play("Run")
			if Input.is_action_pressed("ui_left"):
				motion.x = -flying_speed
				$Sprite.flip_h = true
				$Sprite.play("Run")
			if Input.is_action_pressed("ui_up"):
				motion.y = -flying_speed
			if Input.is_action_pressed("ui_down"):
				motion.y = flying_speed	
			else:
				if motion.y > 0: #moving downward
					motion.y -= (.025 * (motion.y))   #
				elif motion.y < 0:  #moving upward
					motion.y -= (.025 * (motion.y))   #
				if motion.x > 0:  # moving right
					motion.x -= (.025 * (motion.x))
				elif motion.x < 0 : #moving left
					motion.x -= (.025 * (motion.x))
		else:
			print("out of fuel")
			turn_jetpack_off()

	

#should clean up the above? maybe too many if/else


####### experimental code: 
#
#  basically flip gravity and the up direction, walk on the roof. 
#     #if (grav > 0): 
#    	motion.y = -mBase
#    else:
#	   motion.y = mBase
#    up = (Vector2(up.x,-up.y))
#    grav = -grav
#    up.reflect(Vector2(0,1)
#
###### 

	pbar.value = 100*jetfuel/MAX_JETFUEL
	pbar.update()
	motion = move_and_slide(motion, up)
	print(motion)
	

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_F and event.is_action_pressed("toggle jetpack")):
			if jetpack_is_on: 
				turn_jetpack_off()
				#if on floor, need to zero out motion?
			else:
				turn_jetpack_on()
			
		#wait .25 sec (?))
		
		
		#if !jetpack_is_on:
		#	if jetfuel > 5:
		#		turn_jetpack_on()
		#	else:
		#		print("not enough jetfuel")
		#else:
		#	turn_jetpack_off()
	if (event is InputEventKey and event.scancode == KEY_R and not event.is_echo()):
		jetfuel = MAX_JETFUEL
	
	""" A DIFFERENT KIND OF JETPACK
	if (event is InputEventKey and event.scancode == KEY_SPACE):
		motion.y = -(5*grav)
		jetfuel -= 10"""
