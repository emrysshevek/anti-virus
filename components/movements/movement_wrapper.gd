class_name MovementWrapper

var name: String
var type: String
var scene: PackedScene
var node: Movement

func _init(name: String, type: String, scene: PackedScene) -> void:
    self.name = name
    self.type = type
    self.scene = scene

func instantiate() -> Movement:
    node = scene.instantiate()
    return node