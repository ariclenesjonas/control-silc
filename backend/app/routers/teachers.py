from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..models.teacher import Teacher
from ..schemas.teacher import TeacherCreate, TeacherResponse

router = APIRouter()

@router.get("/", response_model=List[TeacherResponse])
def list_teachers(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    """Listar professores."""
    teachers = db.query(Teacher).filter(Teacher.deleted_at.is_(None)).offset(skip).limit(limit).all()
    return teachers

@router.get("/{teacher_id}", response_model=TeacherResponse)
def get_teacher(teacher_id: int, db: Session = Depends(get_db)):
    """Obter professor por ID."""
    teacher = db.query(Teacher).filter(Teacher.id == teacher_id).first()
    
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Professor não encontrado"
        )
    
    return teacher

@router.post("/", response_model=TeacherResponse, status_code=status.HTTP_201_CREATED)
def create_teacher(teacher: TeacherCreate, db: Session = Depends(get_db)):
    """Criar novo professor."""
    db_teacher = Teacher(**teacher.dict())
    db.add(db_teacher)
    db.commit()
    db.refresh(db_teacher)
    return db_teacher
