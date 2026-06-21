from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text()


def test_cards_support_enhancements_editions_and_serialization():
    card = read("src/cards/card_instance.gd")
    for expected in [
        "func scoring_chip_value",
        "func scoring_mult_bonus",
        "func scoring_mult_factor",
        "func to_save_data",
        "static func from_save_data",
        'enhancement == &"bonus"',
        'edition == &"polychrome"',
    ]:
        assert expected in card


def test_deck_supports_mutation_and_persistence():
    deck = read("src/cards/deck_manager.gd")
    for expected in [
        "func all_live_cards",
        "func add_card",
        "func remove_card",
        "func transform_card",
        "func to_save_data",
        "func load_save_data",
    ]:
        assert expected in deck


def test_hand_levels_feed_the_score_pipeline():
    levels = read("src/scoring/hand_levels.gd")
    score = read("src/scoring/score_service.gd")
    assert "class_name HandLevels" in levels
    assert "func upgrade" in levels
    assert "func bonus_for" in levels
    assert "hand_levels: HandLevels = null" in score
    assert "hand_levels.bonus_for(hand_name)" in score
    assert "card.scoring_mult_factor()" in score


def test_consumables_are_in_shop_and_run_controller():
    consumable = read("src/consumables/consumable_definition.gd")
    library = read("src/consumables/starter_consumable_library.gd")
    shop_pool = read("src/shop/shop_pool_definition.gd")
    run = read("src/run/run_controller.gd")
    assert "class_name ConsumableDefinition" in consumable
    for effect_type in ["upgrade_hand", "enhance_card", "add_card", "remove_card"]:
        assert effect_type in consumable
    assert "StarterConsumableLibrary" in library
    assert "StarterConsumableLibrary.build()" in shop_pool
    assert "var hand_levels := HandLevels.new()" in run
    assert "func use_consumable" in run
    assert 'data["deck"] = deck.to_save_data()' in run
    assert 'data["hand_levels"] = hand_levels.to_save_data()' in run
