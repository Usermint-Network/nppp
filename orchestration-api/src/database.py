from functools import lru_cache
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from usermint_secrets.core import get_secret_from_env

@lru_cache(maxsize=1)
def _database_url() -> str:
    url = get_secret_from_env("ORCHESTRATION_DB_URL")  # <-- use your existing env name if different
    if not url:
        raise RuntimeError("ORCHESTRATION_DB_URL not configured")
    return url

@lru_cache(maxsize=1)
def _engine():
    return create_engine(_database_url(), pool_pre_ping=True)

@lru_cache(maxsize=1)
def _SessionLocal():
    return sessionmaker(autocommit=False, autoflush=False, bind=_engine())

def get_db():
    db = _SessionLocal()()
    try:
        yield db
    finally:
        db.close()