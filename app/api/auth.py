from fastapi import APIRouter, HTTPException, Form, Depends
from pydantic import BaseModel

router = APIRouter()

class LoginRequest(BaseModel):
    username: str
    password: str

@router.post("/login")
async def login(request: LoginRequest):
    """User login"""
    if request.username == "admin" and request.password == "password":
        return {"access_token": "jwt-token-123", "token_type": "bearer"}
    raise HTTPException(status_code=401, detail="Invalid credentials")

@router.post("/register")
async def register(email: str, password: str, name: str):
    """Register new user"""
    return {
        "id": "user_1",
        "email": email,
        "name": name,
        "message": "Account created"
    }