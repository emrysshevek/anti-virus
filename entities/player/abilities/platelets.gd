extends Area2D
class_name Platelets

@export var center: Vector2 = Vector2(400, 300) 
@export var radius: float = 100                 
@export var speed: float = 1.0                  
@export var damage_area_scene: PackedScene
@export var number_of_nodes: int = 1

var damage_areas: Array = []

func _ready():
    for i in range(number_of_nodes):
        var damage_area = damage_area_scene.instantiate()
        add_child(damage_area)
        damage_areas.append({
            "node": damage_area,
            "angle": i * (2.0 * PI / number_of_nodes)  
        })

func _process(delta):
    for area_data in damage_areas:
        var node = area_data["node"]
        var angle = area_data["angle"]

        # Update the angle for the nodes
        angle += speed * delta
        angle = fposmod(angle, 2.0 * PI)

        node.position = center + Vector2(cos(angle), sin(angle)) * radius

        # Save the updated angle
        area_data["angle"] = angle

    if Input.is_action_just_pressed("replicate"):
        pickup_platelets()
    if Input.is_action_just_pressed("dereplicate"):
        lose_platelet()

func pickup_platelets():
    var damage_area = damage_area_scene.instantiate()
    add_child(damage_area)
    damage_areas.append({"node": damage_area, "angle": 0.0})
    number_of_nodes += 1
    recalculate_platelets()

func lose_platelet():
    if damage_areas.size() > 0:
        var last_area = damage_areas.pop_back()
        var node = last_area["node"]

        if node:
            node.queue_free()

        number_of_nodes -= 1
        recalculate_platelets()

func recalculate_platelets():
    for i in range(damage_areas.size()):
        var area_data = damage_areas[i]
        area_data["angle"] = i * (2.0 * PI / number_of_nodes)
