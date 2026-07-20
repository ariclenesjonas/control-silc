from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Date, Text, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from ..database import Base

class StudentStatus(str, enum.Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    GRADUATED = "graduated"
    TRANSFERRED = "transferred"
    EXPELLED = "expelled"

class Student(Base):
    """Model for students."""
    __tablename__ = "students"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, unique=True, comment="ID do usuário")
    registration_number = Column(String(50), unique=True, nullable=False, index=True, comment="Número de matrícula")
    birth_date = Column(Date, nullable=False, comment="Data de nascimento")
    gender = Column(String(20), nullable=True, comment="Gênero")
    address = Column(Text, nullable=True, comment="Endereço")
    city = Column(String(100), nullable=True, comment="Cidade")
    state = Column(String(2), nullable=True, comment="Estado")
    zip_code = Column(String(10), nullable=True, comment="CEP")
    guardian_name = Column(String(200), nullable=True, comment="Nome do responsável")
    guardian_phone = Column(String(20), nullable=True, comment="Telefone do responsável")
    guardian_email = Column(String(255), nullable=True, comment="Email do responsável")
    class_id = Column(Integer, ForeignKey("classes.id"), nullable=True, comment="ID da turma")
    status = Column(SQLEnum(StudentStatus), default=StudentStatus.ACTIVE, nullable=False, comment="Status")
    is_active = Column(Boolean, default=True, nullable=False, comment="Ativo/Inativo")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, comment="Data de criação")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False, comment="Data de atualização")
    deleted_at = Column(DateTime, nullable=True, comment="Data de exclusão lógica")
    
    # Relationships
    user = relationship("User", back_populates="student")
    
    class Config:
        from_attributes = True
