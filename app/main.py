from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import website, auth

app = FastAPI(title="Website Builder API")

# ✅ CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Routers
app.include_router(website.router, prefix="/api/v1/websites", tags=["websites"])
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])

# ✅ Root API
@app.get("/")
async def root():
    return {"message": "API LIVE 🔥"}

# ✅ Health Check (IMPORTANT)
@app.get("/health")
def health():
    return {"status": "ok"}