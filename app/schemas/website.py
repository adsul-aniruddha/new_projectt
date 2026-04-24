from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class WebsiteBase(BaseModel):
    name: str
    template: str
    description: Optional[str] = ""

class WebsiteCreate(WebsiteBase):
    pass

class WebsiteResponse(WebsiteBase):
    id: str
    status: str
    created_at: datetime
    preview_url: str
    
    class Config:
        from_attributes = True

class ContactForm(BaseModel):
    name: str
    email: str
    message: str
    

class WebsiteCreate(BaseModel):
    name: str
    template: str = "modern"
    description: Optional[str] = ""

class WebsiteResponse(WebsiteCreate):  # 👈 ADDED
    id: str
    status: str
    created_at: str
    preview_url: str