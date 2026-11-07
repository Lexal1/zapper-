extends CharacterBody2D

const SPEED = 400.0
const ROTATION_SPEED = 1.0 # Adjust for smoother/faster rotation

@export var double_tap_delay := 250

@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashTimer/DashCooldown
@onready var sprite: Sprite2D = $Sprite2D

var last_tap_time := 0
var current_rotation_velocity: float = 0.0
var real_speed := SPEED
var last_dash_key := false ## false = left, true = right
var locked := false

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	if locked == false:
		if Input.is_action_just_pressed("ui_left"):
			try_dash(false)
			last_dash_key = false

		if Input.is_action_just_pressed("ui_right"):
			try_dash(true)
			last_dash_key = true

		if get_parent().current_mode == false:
			sprite.rotation = lerp_angle(sprite.rotation, 0, ROTATION_SPEED * delta * 4)
			match direction.x:
				1.0:
					sprite.frame = 2
				-1.0:
					sprite.frame = 0
				_:
					sprite.frame = 1
		else:
			var idirection = Vector2(direction.y, direction.x)
			if direction != Vector2.ZERO:
				sprite.rotation = lerp_angle(sprite.rotation, clamp(idirection.angle(), deg_to_rad(-55), deg_to_rad(55)), ROTATION_SPEED * delta)
			else: sprite.rotation = lerp_angle(sprite.rotation, 0, ROTATION_SPEED * delta)

	velocity = direction.normalized() * real_speed
	move_and_slide()


func try_dash(right := false) -> void:
	var current_time := Time.get_ticks_msec()
	var last_key = right
	if current_time - last_tap_time < double_tap_delay and last_dash_key == last_key:
		dash_timer.start()
		real_speed = real_speed * 3
		last_tap_time = 0
	else:
		last_tap_time = current_time


func _on_dash_timer_timeout() -> void:
	real_speed = SPEED


func _on_game_mode_changed(mode: Variant) -> void:
	if mode == true:
		sprite.frame = 11
	else: sprite.frame = 1
	locked = false


func _on_game_mode_changing() -> void:
	locked = true
	sprite.frame = 10
