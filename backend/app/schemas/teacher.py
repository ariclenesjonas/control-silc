from pydantic import BaseModel, Field
from typing import Optional
from datetime import date, datetime

class TeacherBase(BaseModel):
    registration_number: str = Field(..., min_length=1)
    birth_date: date
    gender: Optional[str] = None
    specialization: Optional[str] = None
    degree: Optional[str] = None
    hiring_date: date
    salary: Optional[str] = None

class TeacherCreate(TeacherBase):
    user_id: int

class TeacherResponse(TeacherBase):
    id: int
    user_id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
