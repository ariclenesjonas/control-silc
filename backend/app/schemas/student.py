from pydantic import BaseModel, Field
from typing import Optional
from datetime import date, datetime

class StudentBase(BaseModel):
    registration_number: str = Field(..., min_length=1)
    birth_date: date
    gender: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    zip_code: Optional[str] = None
    guardian_name: Optional[str] = None
    guardian_phone: Optional[str] = None
    guardian_email: Optional[str] = None
    class_id: Optional[int] = None

class StudentCreate(StudentBase):
    user_id: int

class StudentResponse(StudentBase):
    id: int
    user_id: int
    status: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
