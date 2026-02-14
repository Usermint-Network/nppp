FROM python:3.11-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Copy requirements from *this* folder (build context)
COPY requirements.txt /app/requirements.txt

# Install deps
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy app code
COPY src/ /app/src/

# Non-root
RUN groupadd -r appuser && useradd -r -g appuser appuser \
 && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

# Cloud Run provides $PORT; keep 8080 as fallback
CMD exec uvicorn src.main:app --host 0.0.0.0 --port ${PORT:-8080} --proxy-headers
