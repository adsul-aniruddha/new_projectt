from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import Website, User
from app.core.jwt import get_current_user

router = APIRouter(prefix="/website", tags=["Website Manage"])


@router.get("/all")
def get_all_websites(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    websites = db.query(Website).filter(
        Website.user_id == current_user.id
    ).all()

    return websites