from fastapi import FastAPI

# 🔥 CREATE APP FIRST
app = FastAPI(title="Website Maker SaaS")

# 🔹 IMPORTS AFTER APP
from app.db.database import Base, engine
from app.db import models

from app.api import auth, request, website, public, website_manage

# 🔹 CREATE TABLES
Base.metadata.create_all(bind=engine)

# 🔹 ROUTES
app.include_router(auth.router)
app.include_router(request.router)
app.include_router(website.router)
app.include_router(public.router)
app.include_router(website_manage.router)

# 🔹 ROOT
@app.get("/")
def root():
    return {"message": "SaaS Running 🚀"}