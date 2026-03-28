from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse   # 👈 ADD THIS

# 🔥 CREATE APP FIRST
app = FastAPI(title="Website Maker SaaS")

# 🔥 CORS (VERY IMPORTANT for Flutter Web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 🔹 IMPORTS AFTER APP
from app.db.database import Base, engine
from app.db import models

from app.api import auth, request, website, public, website_manage

# 🔹 CREATE TABLES
Base.metadata.create_all(bind=engine)

# 🔹 INCLUDE ROUTES
app.include_router(auth.router)
app.include_router(request.router)
app.include_router(website.router)
app.include_router(public.router)
app.include_router(website_manage.router)

# 🔹 ROOT
@app.get("/")
def root():
    return {"message": "SaaS Running 🚀"}


# 🔥 WEBSITE PREVIEW ROUTE (NEW ADD)
@app.get("/site/{id}", response_class=HTMLResponse)
def get_site(id: int):
    return f"""
    <html>
    <head>
        <title>My Website</title>
        <style>
            body {{
                font-family: Arial;
                background: linear-gradient(to right, #141E30, #243B55);
                color: white;
                text-align: center;
                padding: 50px;
            }}
            .card {{
                background: rgba(255,255,255,0.1);
                padding: 30px;
                border-radius: 15px;
                display: inline-block;
            }}
            button {{
                padding: 12px 25px;
                background: teal;
                color: white;
                border: none;
                border-radius: 10px;
                cursor: pointer;
            }}
        </style>
    </head>
    <body>
        <div class="card">
            <h1>🚀 My Business Website</h1>
            <p>This is generated website ID: {id}</p>

            <br><br>

            <button onclick="alert('Contact feature coming soon!')">
                Contact Us
            </button>
        </div>
    </body>
    </html>
    """