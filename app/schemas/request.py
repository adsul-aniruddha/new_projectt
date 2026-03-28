from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import Request
from app.schemas.request_schema import RequestCreate

router = APIRouter(prefix="/request", tags=["Request"])


@router.post("/create")
def create_request(data: RequestCreate, db: Session = Depends(get_db)):
    req = Request(**data.dict())
    db.add(req)
    db.commit()
    db.refresh(req)
    return req
	