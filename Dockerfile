FROM runpod/pytorch:1.0.3-cu1290-torch291-ubuntu2204

RUN pip install --no-cache-dir vllm==0.15.1 runpod==1.7.0 pydantic

WORKDIR /app
COPY handler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY scripts ./scripts

# NOTE: "Qwen/Qwen3-4B-Instruct" does not exist on HF; use the published variant.
ENV MODEL_NAME="Qwen/Qwen3-4B-Instruct-2507"
ENV MAX_MODEL_LEN=4096
ENV TENSOR_PARALLEL_SIZE=1
ENV GPU_MEMORY_UTILIZATION=0.90

CMD ["python", "-u", "handler.py"]
