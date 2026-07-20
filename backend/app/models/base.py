from sqlalchemy import Column, DateTime, Boolean, func
from sqlalchemy.orm import declarative_base
from datetime import datetime

Base = declarative_base()

class BaseModel(Base):
    """Base model with common fields for all models."""
    __abstract__ = True
    
    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        nullable=False,
        comment="Data de criação"
    )
    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
        comment="Data de atualização"
    )
    deleted_at = Column(
        DateTime,
        nullable=True,
        comment="Data de exclusão lógica"
    )
    is_active = Column(
        Boolean,
        default=True,
        nullable=False,
        comment="Ativo/Inativo"
    )
