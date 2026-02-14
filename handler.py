import os
import shutil
import subprocess
import threading
import time
from typing import Any, Dict

import requests
import runpod


def start_max_server() -> None:
    model_path = os.getenv("MODEL_PATH", "modularai/Qwen3-4B-Instruct-GGUF")
    cmd = ["max", "serve", f"--model-path={model_path}", "--port=8000"]
    if shutil.which("max") is None:
        raise RuntimeError("`max` CLI not found in PATH; Modular MAX is not installed correctly.")
    subprocess.Popen(cmd)


threading.Thread(target=start_max_server, daemon=True).start()

# Model download / load can exceed 30s on first boot.
deadline = time.time() + int(os.getenv("MAX_BOOT_WAIT", "600"))
while True:
    try:
        # Port open check
        r = requests.get("http://localhost:8000", timeout=2)
        # Any HTTP response means the server is up.
        _ = r.status_code
        break
    except Exception:
        if time.time() >= deadline:
            break
        time.sleep(5)

MAX_URL = "http://localhost:8000/v1/completions"


def handler(job: Dict[str, Any]) -> Dict[str, Any]:
    try:
        data = job.get("input", {})
        payload = {
            "model": "qwen3-4b",
            "prompt": data.get("prompt", ""),
            "max_tokens": data.get("max_tokens", 100),
            "temperature": data.get("temperature", 0.7),
        }
        response = requests.post(MAX_URL, json=payload, timeout=30)
        response.raise_for_status()
        result = response.json()
        return {"output": result["choices"][0]["text"], "status": "success"}
    except Exception as exc:
        return {"error": str(exc), "status": "error"}


runpod.serverless.start({"handler": handler})
