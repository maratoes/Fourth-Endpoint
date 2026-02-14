FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# System pip on Ubuntu can be old and occasionally breaks dependency resolution.
RUN python3.10 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Install Modular toolchain (provides `modular` + `max`).
# The installer script expects bash (not /bin/sh).
RUN curl -fsSL https://get.modular.com | bash
ENV PATH="/root/.modular/bin:${PATH}"
RUN /root/.modular/bin/modular --version && /root/.modular/bin/modular install max && /root/.modular/bin/max --version

RUN python3.10 -m pip install --no-cache-dir runpod==1.7.0 requests

WORKDIR /app
COPY handler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MODEL_PATH="modularai/Qwen3-4B-Instruct-GGUF"

CMD ["python3", "-u", "handler.py"]
