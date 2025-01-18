class_name FungusState
extends EnemyState

var fungus: Fungus

func _ready() -> void:
    await owner.ready
    fungus = owner as Fungus
    assert(fungus != null, "The fungus state type must be used only in the fungus scene. It needs the owner to be a fungus node.")