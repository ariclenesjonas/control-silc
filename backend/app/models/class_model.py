from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from ..database import Base

class Class(Base):
    """Model for classes/groups."""
    __tablename__ = "classes"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(100), nullable=False, comment="Nome da turma")
    code = Column(String(50), unique=True, nullable=False, index=True, comment="Código")
    level = Column(String(50), nullable=False, comment="Nível (1º ano, 2º ano, etc)")
    year = Column(Integer, nullable=False, comment="Ano letivo")
    semester = Column(Integer, nullable=True, comment="Semestre")
    capacity = Column(Integer, default=30, comment="Capacidade de alunos")
    description = Column(Text, nullable=True, comment="Descrição")
    is_active = Column(Boolean, default=True, nullable=False, comment="Ativo/Inativo")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, comment="Data de criação")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False, comment="Data de atualização")
    deleted_at = Column(DateTime, nullable=True, comment="Data de exclusão lógica")
    
    # Relationships
    students = relationship("Student", back_populates="class")
    
    class Config:
        from_attributes = True
