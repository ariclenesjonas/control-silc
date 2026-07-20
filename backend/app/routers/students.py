from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..models.student import Student
from ..schemas.student import StudentCreate, StudentResponse

router = APIRouter()

@router.get("/", response_model=List[StudentResponse])
def list_students(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    """Listar alunos."""
    students = db.query(Student).filter(Student.deleted_at.is_(None)).offset(skip).limit(limit).all()
    return students

@router.get("/{student_id}", response_model=StudentResponse)
def get_student(student_id: int, db: Session = Depends(get_db)):
    """Obter aluno por ID."""
    student = db.query(Student).filter(Student.id == student_id).first()
    
    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Aluno não encontrado"
        )
    
    return student

@router.post("/", response_model=StudentResponse, status_code=status.HTTP_201_CREATED)
def create_student(student: StudentCreate, db: Session = Depends(get_db)):
    """Criar novo aluno."""
    db_student = Student(**student.dict())
    db.add(db_student)
    db.commit()
    db.refresh(db_student)
    return db_student
