from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, Float
from datetime import datetime
from ..database import Base

class Discipline(Base):
    """Model for disciplines/subjects."""
    __tablename__ = "disciplines"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(150), nullable=False, comment="Nome da disciplina")
    code = Column(String(50), unique=True, nullable=False, index=True, comment="Código")
    description = Column(Text, nullable=True, comment="Descrição")
    workload = Column(Integer, nullable=False, comment="Carga horária em horas")
    credit_hours = Column(Float, nullable=True, comment="Créditos")
    is_active = Column(Boolean, default=True, nullable=False, comment="Ativo/Inativo")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, comment="Data de criação")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False, comment="Data de atualização")
    deleted_at = Column(DateTime, nullable=True, comment="Data de exclusão lógica")
    
    class Config:
        from_attributes = True
