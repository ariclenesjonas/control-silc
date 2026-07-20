from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Date, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from ..database import Base

class Teacher(Base):
    """Model for teachers."""
    __tablename__ = "teachers"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, unique=True, comment="ID do usuário")
    registration_number = Column(String(50), unique=True, nullable=False, index=True, comment="Número de registro")
    birth_date = Column(Date, nullable=False, comment="Data de nascimento")
    gender = Column(String(20), nullable=True, comment="Gênero")
    specialization = Column(String(200), nullable=True, comment="Especialização")
    degree = Column(String(100), nullable=True, comment="Grau")
    hiring_date = Column(Date, nullable=False, comment="Data de contratação")
    salary = Column(String(20), nullable=True, comment="Salário")
    is_active = Column(Boolean, default=True, nullable=False, comment="Ativo/Inativo")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, comment="Data de criação")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False, comment="Data de atualização")
    deleted_at = Column(DateTime, nullable=True, comment="Data de exclusão lógica")
    
    # Relationships
    user = relationship("User", back_populates="teacher")
    
    class Config:
        from_attributes = True
