from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_framework_files_exist():
    expected = [
        "project.godot",
        "scenes/Main.tscn",
        "scenes/run/RunController.tscn",
        "src/cards/deck_manager.gd",
        "src/scoring/hand_evaluator.gd",
        "src/scoring/score_service.gd",
        "src/run/run_controller.gd",
    ]
    missing = [path for path in expected if not (ROOT / path).exists()]
    assert not missing, f"Missing framework files: {missing}"


def test_project_registers_autoloads_and_main_scene():
    project = (ROOT / "project.godot").read_text()
    assert 'run/main_scene="res://scenes/Main.tscn"' in project
    for autoload in ["GameConfig", "RunRng", "SaveService", "AudioBus"]:
        assert f'{autoload}="*res://src/autoloads/' in project


def test_hand_evaluator_declares_core_hands():
    evaluator = (ROOT / "src/scoring/hand_evaluator.gd").read_text()
    for hand in [
        "High Card",
        "Pair",
        "Two Pair",
        "Three of a Kind",
        "Straight",
        "Flush",
        "Full House",
        "Four of a Kind",
        "Straight Flush",
    ]:
        assert hand in evaluator
