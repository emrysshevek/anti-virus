class_name FungusState
extends EnemyState

var fungus: Fungus

func _ready() -> void:
    await owner.ready
    print(owner.name)
    fungus = owner as Fungus
    print(fungus)
    assert(fungus != null, "The fungus state type must be used only in the fungus scene. It needs the owner to be a fungus node.")