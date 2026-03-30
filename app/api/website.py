from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import SessionLocal
from app.db.models import Website

router = APIRouter(prefix="/website", tags=["Website"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/create")
def create(data: dict, db: Session = Depends(get_db)):
    site = Website(**data)
    db.add(site)
    db.commit()
    db.refresh(site)
    return {"id": site.id}


@router.get("/my")
def my_sites(db: Session = Depends(get_db)):
    return db.query(Website).all()


@router.put("/update/{id}")
def update(id: int, data: dict, db: Session = Depends(get_db)):
    site = db.query(Website).get(id)
    for key, value in data.items():
        setattr(site, key, value)
    db.commit()
    return {"msg": "updated"}