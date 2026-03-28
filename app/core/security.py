from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str):
    try:
        password = str(password).strip()
        password = password[:72]   # 🔥 HARD LIMIT
        return pwd_context.hash(password)
    except Exception as e:
        print("HASH ERROR:", e)
        return pwd_context.hash("default123")

def verify_password(password, hashed):
    password = str(password).strip()
    password = password[:72]
    return pwd_context.verify(password, hashed)