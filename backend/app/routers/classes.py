from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..models.class_model import Class
from ..schemas.class_schema import ClassCreate, ClassResponse

router = APIRouter()

@router.get("/", response_model=List[ClassResponse])
def list_classes(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    """Listar turmas."""
    classes = db.query(Class).filter(Class.deleted_at.is_(None)).offset(skip).limit(limit).all()
    return classes

@router.get("/{class_id}", response_model=ClassResponse)
def get_class(class_id: int, db: Session = Depends(get_db)):
    """Obter turma por ID."""
    class_obj = db.query(Class).filter(Class.id == class_id).first()
    
    if not class_obj:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Turma não encontrada"
        )
    
    return class_obj

@router.post("/", response_model=ClassResponse, status_code=status.HTTP_201_CREATED)
def create_class(class_obj: ClassCreate, db: Session = Depends(get_db)):
    """Criar nova turma."""
    db_class = Class(**class_obj.dict())
    db.add(db_class)
    db.commit()
    db.refresh(db_class)
    return db_class
