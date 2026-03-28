from sqlalchemy import Column, Integer, String, Text, DateTime
from datetime import datetime
from app.db.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)

class Request(Base):
    __tablename__ = "requests"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    business_type = Column(String)
    description = Column(Text)
    color = Column(String)
    user_id = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)


class Website(Base):
    __tablename__ = "websites"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    html = Column(Text)
    request_id = Column(Integer)
    user_id = Column(Integer)
    password = Column(String)