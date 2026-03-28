from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import Request, Website

router = APIRouter(prefix="/website", tags=["Website"])


def generate_html(req):
    return f"""
    <html>
    <head>
        <title>{req.name}</title>
        <style>
            body {{ background-color: {req.color}; font-family: Arial; }}
        </style>
    </head>
    <body>
        <h1>{req.business_type}</h1>
        <p>{req.description}</p>
        <button>Contact Us</button>
    </body>
    </html>
    """


@router.post("/generate/{request_id}")
def generate_site(request_id: int, db: Session = Depends(get_db)):
    req = db.query(Request).filter(Request.id == request_id).first()

    if not req:
        return {"error": "Request not found"}

    html = generate_html(req)

    site = Website(
        name=req.name,
        html=html,
        request_id=req.id
    )

    db.add(site)
    db.commit()
    db.refresh(site)

    return site