class_name Card extends Button

signal put_back

@export var threshold: float = 100.0
@export var threshold_speed: float = 200.0
@export var use_speed: bool = true

var tween_grab: Tween
var tween_movement: Tween
var picked_up: bool = false
var offset: Vector2
var is_3D: bool = true
var last_speed: float = 0.0

var card_info : Dictionary

@onready var original_position: Vector2 = global_position
@onready var card_texture: TextureRect = $CardTexture
@onready var shadow: TextureRect = $Shadow
#@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var card_types = {
	#"red_cards" : preload("res://assets/cards/Designer(7).jpeg"),
	#"green_cards" : preload("res://assets/cards/ffcard.webp"),
	"red_cards" : preload("res://assets/cards/red_card.webp"),
	"green_cards" : preload("res://assets/cards/green_card.webp"),
	"blue_cards" : preload("res://assets/cards/blue_card.jpeg"),
}

@export var color:Color:
	set(new_val):
		color = new_val
		self.self_modulate = new_val
	get:
		return self.self_modulate
		
@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2




func _ready() -> void:
	set_process(false)
	pivot_offset = size / 2.0
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	#collision_shape.set_deferred("disabled", true)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	global_position = get_global_mouse_position() + offset
	rotate_velocity(delta)
	handle_shadow(delta)
	follow_mouse(delta)

func card_set_type(card_type : String):
	card_texture.texture = card_types[card_type]
	shadow.texture = card_types[card_type]

func card_set_info(info):
	card_info = info
	
	


func destroy() -> void:
	card_texture.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 2.0).from(1.0)
	tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 1.0)

func set_3D_rotation_x(x: float) -> void:
	#$SubViewportContainer.material.set_shader_parameter("x_rot", x)
	card_texture.material.set_shader_parameter("x_rot", x)
	
func set_3D_rotation_y(y: float) -> void:
	#$SubViewportContainer.material.set_shader_parameter("y_rot", y)
	card_texture.material.set_shader_parameter("y_rot", y)

func _on_button_down() -> void:
	if Engine.is_editor_hint(): return
	offset = global_position - get_global_mouse_position()
	picked_up = true
	set_process(true)
	if tween_grab and tween_grab.is_running():
		tween_grab.kill()
	tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_grab.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)

func _on_button_up() -> void:
	if Engine.is_editor_hint(): return
	picked_up = false
	set_process(false)
	var dist: float = abs(original_position.y - global_position.y)
	#print("Distance: ", dist)
	
	if use_speed:
		if last_speed <= -threshold_speed:
			# Go to new position
			put_back.emit()
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			if is_3D:
				tween_movement.tween_method(set_3D_rotation_x, 0.0, 360.0, 0.5)
			else:
				tween_movement.tween_property(self, "rotation_degrees", 360.0, 0.4).from(0.0)
		else:
			if tween_grab and tween_grab.is_running():
				tween_grab.kill()
			tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_grab.tween_property(self, "scale", Vector2.ONE, 0.15)
			
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_movement.tween_property(self, "global_position", original_position, 0.3)
	else:
		if dist > threshold:
			# Go to new position
			put_back.emit()
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			if is_3D:
				tween_movement.tween_method(set_3D_rotation_x, 0.0, 360.0, 0.5)
			else:
				tween_movement.tween_property(self, "rotation_degrees", 360.0, 0.4).from(0.0)
		else:
			if tween_grab and tween_grab.is_running():
				tween_grab.kill()
			tween_grab = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_grab.tween_property(self, "scale", Vector2.ONE, 0.15)
			
			if tween_movement and tween_movement.is_running():
				tween_movement.kill()
			tween_movement = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_movement.tween_property(self, "global_position", original_position, 0.3)

#func _on_gui_input(event: InputEvent) -> void:
	#if not picked_up: return
	#if event is InputEventMouseMotion:
		##print("speed: ", event.velocity)
		#last_speed = event.velocity.y



func rotate_velocity(delta: float) -> void:
	if not following_mouse: return
	var center_pos: Vector2 = global_position - (size/2.0)
	#print("Pos: ", center_pos)
	#print("Pos: ", last_pos)
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	#print("Velocity: ", velocity)
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement

func handle_shadow(delta: float) -> void:
	# Y position is enver changed.
	# Only x changes depending on how far we are from the center of the screen
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/(center.x)))

func follow_mouse(delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2.0)

func handle_mouse_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed():
		following_mouse = true
	else:
		# drop card
		following_mouse = false
		#collision_shape.set_deferred("disabled", false)
		if tween_handle and tween_handle.is_running():
			tween_handle.kill()
		tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_handle.tween_property(self, "rotation", 0.0, 0.3)

func _on_gui_input(event: InputEvent) -> void:
		#if not picked_up: return
	#if picked_up && event is InputEventMouseMotion:
		##print("speed: ", event.velocity)
		#last_speed = event.velocity.y

	handle_mouse_click(event)
	
	# Don't compute rotation when moving the card
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	# Handles rotation
	# Get local mouse pos
	var mouse_pos: Vector2 = get_local_mouse_position()
	#print("Mouse: ", mouse_pos)
	#print("Card: ", position + size)
	var diff: Vector2 = (position + size) - mouse_pos

	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	#print("Lerp val x: ", lerp_val_x)
	#print("lerp val y: ", lerp_val_y)

	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	#print("Rot x: ", rot_x)
	#print("Rot y: ", rot_y)
	
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)

func _on_mouse_exited() -> void:
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)
	
	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
