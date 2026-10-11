#!/bin/bash
# llama.cpp server for OpenCode — Qwen3.8-27B, 4 parallel slots on one GPU.
# Ctrl-C stops it. Override the model with MODEL=... if you want.
exec llama serve \
  -hf "${MODEL:-unsloth/Qwen3.8-27B-GGUF:UD-IQ3_XXS}" \
  -ngl 99 \
  -c 200000 \
  --parallel 4 \
  -fa on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --jinja \
  --host 127.0.0.1 \
  --no-reasoning-preserve \
  --port 8090
