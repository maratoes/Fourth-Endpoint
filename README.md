# Fourth Endpoint (Fallback, Modular MAX)

RunPod serverless fallback endpoint using Modular MAX and `Qwen3-4B-Instruct-GGUF`.

## Build

```bash
./scripts/build.sh
```

## Push

```bash
./scripts/push.sh
```

## RunPod settings

- GPU: NVIDIA L4
- Workers: min `0`, max `2`
- Idle timeout: `30s`
- Env:
  - `MODEL_PATH=modularai/Qwen3-4B-Instruct-GGUF`
