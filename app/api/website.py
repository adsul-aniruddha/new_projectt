from fastapi import APIRouter, HTTPException
from app.schemas.website import WebsiteCreate, WebsiteResponse
from app.services.website_service import WebsiteService
from typing import List

router = APIRouter()
service = WebsiteService()

@router.post("/", response_model=WebsiteResponse)
async def create_website(website: WebsiteCreate):
    return service.create_website(website.dict())

@router.get("/", response_model=List[dict])
async def list_websites():
    return service.list_websites()

@router.get("/{website_id}")
async def get_website(website_id: str):
    result = service.get_website(website_id)
    if not result:
        raise HTTPException(404, "Not found")
    return result

@router.get("/site/{site_id}")
async def get_site_preview(site_id: str):
    return {"html": service.get_site_html(site_id)}

@router.get("/site/{site_id}/about")
async def get_about(site_id: str):
    return {"html": service.get_page_html(site_id, "about")}

@router.get("/site/{site_id}/contact")
async def get_contact(site_id: str):
    return {"html": service.get_page_html(site_id, "contact")}

@router.post("/contact/{site_id}")
async def submit_contact(site_id: str, data: dict):
    service.save_contact_form(site_id, data)
    return {"message": "Sent"}

@router.delete("/{website_id}")
async def delete_website(website_id: str):
    service.delete_website(website_id)
    return {"message": "Deleted"}

@router.get("/website/all")
async def get_all():
    return service.get_all_public_websites()