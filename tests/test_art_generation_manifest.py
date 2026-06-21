import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROMPTS = ROOT / "assets/art/prompts/gpt-image-2-assets.jsonl"


def test_gpt_image_2_art_manifest_has_project_assets():
    jobs = [json.loads(line) for line in PROMPTS.read_text().splitlines() if line.strip()]
    assert {job["id"] for job in jobs} == {
        "table-background",
        "card-back",
        "modifier-badge",
        "consumable-badge",
    }
    for job in jobs:
        assert job["quality"] == "high"
        assert job["out"].startswith("assets/art/generated/")
        assert "no Balatro branding" in job["prompt"] or "no logos" in job["prompt"]


def test_art_generation_script_uses_gpt_image_2_cli():
    script = (ROOT / "scripts/generate_art_assets.sh").read_text()
    assert "--model gpt-image-2" in script
    assert "OPENAI_API_KEY is required" in script
    assert "assets/art/prompts/gpt-image-2-assets.jsonl" in script
