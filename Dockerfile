FROM ubuntu:22.04

RUN apt-get update && apt-get install -y python3.10 python3-pip curl && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir modular runpod==1.6.2 requests

WORKDIR /app
COPY handler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MODEL_PATH="modularai/Qwen3-4B-Instruct-GGUF"

CMD ["python3", "-u", "handler.py"]
