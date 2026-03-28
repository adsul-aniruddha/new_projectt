from pydantic import BaseModel


class RequestCreate(BaseModel):
    name: str
    business_type: str
    description: str
    color: str