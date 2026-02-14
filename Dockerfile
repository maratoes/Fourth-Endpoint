FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Modular properly so the `max` CLI exists.
# The simple `pip install modular` frequently does not provide `max` in minimal images.
RUN curl -fsSL https://get.modular.com | sh
ENV PATH="/root/.modular/bin:${PATH}"
RUN modular --version && modular install max && max --version

RUN pip install --no-cache-dir runpod==1.7.0 requests

WORKDIR /app
COPY handler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MODEL_PATH="modularai/Qwen3-4B-Instruct-GGUF"

CMD ["python3", "-u", "handler.py"]
