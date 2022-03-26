extends RayCast2D

var is_casting:=false setget set_is_casting
var event_location=Vector2(0,0)
export var cast_speed := 7000.0
export var max_length := 1400.0

onready var tween := $Tween
onready var fill := $Line2D
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var line_width: float = fill.width
export var growth_time := 0.1

func _physics_process(delta):
	if(is_casting):
			cast_to = (event_location*cast_speed).clamped(max_length)
			var cast_point:=cast_to
			force_raycast_update()
			collision_particles.emitting = is_colliding()
			if(is_colliding()):
					if(get_collider() is StaticBody2D):
						collision_particles.global_rotation_degrees = get_collision_normal().angle()
						cast_point=to_local(get_collision_point())
						collision_particles.position = to_local(get_collision_point())
						#$Line2D.add_point(cast_point)
						#$BeamParticles2D.position = cast_point*0.5
			
			$BeamParticles2D.position = cast_point*0.5
			$Line2D.points[1]=cast_point
	else:
		collision_particles.emitting=false;
		beam_particles.emitting=false;
		casting_particles.emitting=false;
	
func _unhandled_input(event:InputEvent):
	#if((event is InputEventMouseButton)or(event is InputEventScreenTouch)):
		if(event.is_pressed()):
			if((event is InputEventMouseMotion) or (event is InputEventScreenDrag)):
				event_location=event.get_position()
				print("k")
				set_is_casting(true)
		else:
			set_is_casting(false)
		
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	$CastingParticles2D.emitting=is_casting
	if is_casting:
		appear()
	else: 
		$CastingParticles2D.emitting=false
		disappear()
	
	set_physics_process(is_casting)
	
func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()


func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
