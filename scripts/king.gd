extends CharacterBody2D
@export var move_speed:float = 100
@export var run_speed:float = 180
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready() -> void:
	update_animation_parameters(starting_direction)

func _physics_process(_delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength('Right') - Input.get_action_strength('Left'),
		Input.get_action_strength('Down') - Input.get_action_strength('Up')
	)

	input_direction = input_direction.normalized()
		
	update_animation_parameters(input_direction)

	if Input.is_action_pressed("Run"):
		velocity = input_direction*run_speed
	else:
		velocity = input_direction * move_speed
	
	move_and_slide()
	
func update_animation_parameters(move_inputs : Vector2) -> void:
	if move_inputs != Vector2.ZERO:
		var animation_direction = Vector2(move_inputs.x, -move_inputs.y)
		animation_tree.set("parameters/Idle/blend_position",animation_direction)
		animation_tree.set("parameters/Walk/blend_position",move_inputs)
		animation_tree.set("parameters/Run/blend_position",animation_direction)
		if Input.is_action_pressed("Run"):
			state_machine.travel("Run")
		else:
			state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
