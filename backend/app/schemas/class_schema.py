from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class ClassBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    code: str = Field(..., min_length=1, max_length=50)
    level: str = Field(..., min_length=1)
    year: int
    semester: Optional[int] = None
    capacity: int = Field(default=30, gt=0)
    description: Optional[str] = None

class ClassCreate(ClassBase):
    pass

class ClassResponse(ClassBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
