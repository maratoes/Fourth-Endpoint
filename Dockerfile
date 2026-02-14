FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Modular CLI, then use it to install MAX so `max` exists.
RUN pip install --no-cache-dir modular
RUN modular --version && modular install max && max --version

RUN pip install --no-cache-dir runpod==1.7.0 requests

WORKDIR /app
COPY handler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MODEL_PATH="modularai/Qwen3-4B-Instruct-GGUF"

CMD ["python3", "-u", "handler.py"]
