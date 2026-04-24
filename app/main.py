from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import website, auth  # Your imports

app = FastAPI(title="Website Builder API")

# 👈 CORS AFTER app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(website.router, prefix="/api/v1/websites", tags=["websites"])
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])

@app.get("/")
async def root():
    return {"message": "API LIVE 🔥"}
    @app.get("/health")
def health():
    return {"status": "ok"}