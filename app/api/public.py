
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from fastapi.responses import HTMLResponse
from app.db.database import get_db
from app.db.models import Website

router = APIRouter(tags=["Public"])


@router.get("/site/{id}", response_class=HTMLResponse)
def get_site(id: int, db: Session = Depends(get_db)):
    site = db.query(Website).filter(Website.id == id).first()
    return site.html