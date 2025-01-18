class_name BacteriophageState
extends EnemyState

const CHASE := "Chase"
const HOVER := "Hover"
const ESCAPE := "Escape"

var bacteria: Bacteriophage

func _ready() -> void:
    await owner.ready
    bacteria = owner as Bacteriophage
    assert(bacteria != null, "The bacteria state type must be used only in the bacteria scene. It needs the owner to be a bacteria node.")