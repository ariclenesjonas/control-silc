from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..models.discipline import Discipline
from ..schemas.discipline import DisciplineCreate, DisciplineResponse

router = APIRouter()

@router.get("/", response_model=List[DisciplineResponse])
def list_disciplines(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    """Listar disciplinas."""
    disciplines = db.query(Discipline).filter(Discipline.deleted_at.is_(None)).offset(skip).limit(limit).all()
    return disciplines

@router.get("/{discipline_id}", response_model=DisciplineResponse)
def get_discipline(discipline_id: int, db: Session = Depends(get_db)):
    """Obter disciplina por ID."""
    discipline = db.query(Discipline).filter(Discipline.id == discipline_id).first()
    
    if not discipline:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Disciplina não encontrada"
        )
    
    return discipline

@router.post("/", response_model=DisciplineResponse, status_code=status.HTTP_201_CREATED)
def create_discipline(discipline: DisciplineCreate, db: Session = Depends(get_db)):
    """Criar nova disciplina."""
    db_discipline = Discipline(**discipline.dict())
    db.add(db_discipline)
    db.commit()
    db.refresh(db_discipline)
    return db_discipline
