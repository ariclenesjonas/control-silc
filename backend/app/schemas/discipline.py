from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class DisciplineBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=150)
    code: str = Field(..., min_length=1, max_length=50)
    description: Optional[str] = None
    workload: int = Field(..., gt=0)
    credit_hours: Optional[float] = None

class DisciplineCreate(DisciplineBase):
    pass

class DisciplineResponse(DisciplineBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
