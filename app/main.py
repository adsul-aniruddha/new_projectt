from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session

# 🔥 CREATE APP
app = FastAPI(title="Website Maker SaaS")

# 🔥 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 🔹 IMPORTS
from app.db.database import Base, engine, SessionLocal
from app.db import models

from app.api import auth, website, public, website_manage

# 🔹 CREATE TABLES
Base.metadata.create_all(bind=engine)

# 🔹 ROUTES
app.include_router(auth.router)
app.include_router(website.router)
app.include_router(public.router)
app.include_router(website_manage.router)

# 🔹 ROOT
@app.get("/")
def root():
    return {"message": "SaaS Running 🚀"}


# ===============================
# 🔥 DB DEPENDENCY (CORRECT)
# ===============================
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ===============================
# 🔥 WEBSITE MAIN PAGE
# ===============================
@app.get("/site/{id}", response_class=HTMLResponse)
def get_site(id: int):
    db = SessionLocal()
    site = db.query(models.Website).get(id)

    if not site:
        return "<h1>Website Not Found</h1>"

    # 🔥 Increase views
    site.views += 1
    db.commit()

    # 🔥 Template system
    if site.template == "Modern":
        bg = "linear-gradient(to right,#141E30,#243B55)"
    elif site.template == "Classic":
        bg = "#f4f4f4;color:black"
    else:
        bg = "black;color:white"

    return f"""
    <html>
    <head>
        <title>{site.name}</title>
        <style>
            body {{
                font-family: Arial;
                background: {bg};
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
            a {{
                margin: 10px;
                display: inline-block;
                color: cyan;
            }}
        </style>
    </head>
    <body>
        <div class="card">
            <h1>{site.business_type}</h1>
            <h2>{site.name}</h2>
            <p>{site.description}</p>

            <h4>👀 Views: {site.views}</h4>

            <br>

            <a href="/site/{id}/about">About</a>
            <a href="/site/{id}/contact">Contact</a>

            <br><br>

            <button onclick="alert('Email: {site.email}')">
                Contact Us
            </button>
        </div>
    </body>
    </html>
    """


# ===============================
# 🔥 ABOUT PAGE
# ===============================
@app.get("/site/{id}/about", response_class=HTMLResponse)
def about(id: int):
    db = SessionLocal()
    site = db.query(models.Website).get(id)

    return f"""
    <html>
    <body style="font-family:Arial;text-align:center;padding:50px;">
        <h1>About {site.name}</h1>
        <p>{site.description}</p>
        <a href="/site/{id}">⬅ Back</a>
    </body>
    </html>
    """


# ===============================
# 🔥 CONTACT PAGE
# ===============================
@app.get("/site/{id}/contact", response_class=HTMLResponse)
def contact_page(id: int):
    return f"""
    <html>
    <body style="font-family:Arial;text-align:center;padding:50px;">
        <h1>Contact Us</h1>

        <form method="post" action="/contact/{id}">
            <input name="name" placeholder="Your Name"/><br><br>
            <input name="email" placeholder="Email"/><br><br>
            <textarea name="message" placeholder="Message"></textarea><br><br>
            <button type="submit">Send</button>
        </form>

        <br>
        <a href="/site/{id}">⬅ Back</a>
    </body>
    </html>
    """


# ===============================
# 🔥 CONTACT FORM API
# ===============================
@app.post("/contact/{id}")
def contact_submit(id: int):
    return {"msg": "Message received ✅"}