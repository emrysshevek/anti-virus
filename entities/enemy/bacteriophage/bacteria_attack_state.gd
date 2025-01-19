class_name BacteriaAttackState
extends BacteriophageState

func enter(_previous_state_path: String, _data := {}) -> void:
    var attacks = 6
    bacteria.ap.stop()
    bacteria.ap.play("slam")
    bacteria.spawner.spawn(attacks, .75)
    # for i in range(attacks - 1):
    #     bacteria.ap.queue("slam")

func physics_update(_delta: float) -> void:
    finished.emit(COOLDOWN)