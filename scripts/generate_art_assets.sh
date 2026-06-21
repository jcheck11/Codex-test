#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
IMAGE_GEN="$CODEX_HOME/skills/.system/imagegen/scripts/image_gen.py"
PROMPTS="assets/art/prompts/gpt-image-2-assets.jsonl"

if [[ ! -f "$IMAGE_GEN" ]]; then
  echo "Missing image generation CLI: $IMAGE_GEN" >&2
  exit 1
fi

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "OPENAI_API_KEY is required to generate art assets with gpt-image-2." >&2
  exit 1
fi

mkdir -p assets/art/generated
while IFS= read -r job; do
  [[ -z "$job" ]] && continue
  asset_id=$(python -c 'import json,sys; print(json.loads(sys.argv[1])["id"])' "$job")
  prompt=$(python -c 'import json,sys; print(json.loads(sys.argv[1])["prompt"])' "$job")
  size=$(python -c 'import json,sys; print(json.loads(sys.argv[1])["size"])' "$job")
  quality=$(python -c 'import json,sys; print(json.loads(sys.argv[1])["quality"])' "$job")
  out=$(python -c 'import json,sys; print(json.loads(sys.argv[1])["out"])' "$job")
  echo "Generating ${asset_id} -> ${out}"
  python "$IMAGE_GEN" generate \
    --model gpt-image-2 \
    --prompt "$prompt" \
    --size "$size" \
    --quality "$quality" \
    --out "$out" \
    --force
done < "$PROMPTS"
