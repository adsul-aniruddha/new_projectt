from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import Request, User
from app.schemas.request_schema import RequestCreate
from app.core.jwt import get_current_user

router = APIRouter(prefix="/request", tags=["Request"])   # 🔥 IMPORTANT


@router.post("/create")
def create_request(
    data: RequestCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    req = Request(**data.dict(), user_id=current_user.id)

    db.add(req)
    db.commit()
    db.refresh(req)

    return req