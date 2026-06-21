from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text()


def test_modifier_and_shop_resources_exist():
    expected = [
        "src/modifiers/modifier_definition.gd",
        "src/modifiers/starter_modifier_library.gd",
        "src/shop/shop_pool_definition.gd",
    ]
    missing = [path for path in expected if not (ROOT / path).exists()]
    assert not missing, f"Missing feature resource files: {missing}"


def test_scoring_pipeline_passes_hand_name_to_modifiers():
    score_service = read("src/scoring/score_service.gd")
    assert "modifier.apply_score(cards, hand_name, chips, mult)" in score_service
    modifier = read("src/modifiers/modifier_definition.gd")
    assert "func apply_score(cards: Array[CardInstance], hand_name: StringName, chips: int, mult: int)" in modifier
    assert "suit_chips" in modifier
    assert "hand_mult" in modifier


def test_run_controller_supports_rewards_shop_rerolls_and_save_load():
    run_controller = read("src/run/run_controller.gd")
    for expected in [
        "signal shop_opened",
        "var shop_pool := ShopPoolDefinition.starter_pool()",
        "func buy_shop_item",
        "func reroll_shop",
        "func save_run",
        "func load_run",
        "state.money += reward",
    ]:
        assert expected in run_controller


def test_blinds_define_default_small_big_and_boss_sequence():
    blinds = read("src/blinds/blind_definition.gd")
    for expected in ["Small Blind", "Big Blind", "Boss Blind", "default_blinds"]:
        assert expected in blinds


def test_run_state_has_versioned_save_data():
    run_state = read("src/run/run_state.gd")
    assert '"version": 1' in run_state
    assert "func to_save_data" in run_state
    assert "func load_save_data" in run_state
