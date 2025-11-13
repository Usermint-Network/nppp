FROM python:3.11-slim

WORKDIR /app

COPY src/ /app/src

RUN pip install --no-cache-dir fastapi uvicorn

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]

$PORT = 8080
