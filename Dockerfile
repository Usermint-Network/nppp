FROM python:3.11-slim
WORKDIR /app
COPY pyproject.toml /app/
RUN pip install --no-cache-dir fastapi uvicorn[standard] pydantic redis requests google-cloud-storage
COPY src/ /app/src
EXPOSE 8080
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y ffmpeg python3-pip && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY src/ /app
RUN pip3 install google-cloud-storage
CMD ["python3", "worker.py"]
