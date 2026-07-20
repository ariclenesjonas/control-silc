from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Text, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from ..database import Base

class UserStatus(str, enum.Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    DELETED = "deleted"

class User(Base):
    """Model for users."""
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    email = Column(String(255), unique=True, nullable=False, index=True, comment="Email único")
    username = Column(String(100), unique=True, nullable=False, index=True, comment="Nome de usuário")
    password_hash = Column(String(255), nullable=False, comment="Hash da senha")
    first_name = Column(String(150), nullable=True, comment="Primeiro nome")
    last_name = Column(String(150), nullable=True, comment="Sobrenome")
    profile_picture = Column(Text, nullable=True, comment="URL da foto de perfil")
    phone = Column(String(20), nullable=True, comment="Telefone")
    cpf = Column(String(11), unique=True, nullable=True, index=True, comment="CPF")
    role_id = Column(Integer, ForeignKey("roles.id"), nullable=False, comment="ID do perfil")
    institution_id = Column(Integer, nullable=True, comment="ID da instituição")
    status = Column(SQLEnum(UserStatus), default=UserStatus.ACTIVE, nullable=False, comment="Status")
    is_active = Column(Boolean, default=True, nullable=False, comment="Ativo/Inativo")
    last_login = Column(DateTime, nullable=True, comment="Último login")
    login_attempts = Column(Integer, default=0, comment="Tentativas de login falhadas")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, comment="Data de criação")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False, comment="Data de atualização")
    deleted_at = Column(DateTime, nullable=True, comment="Data de exclusão lógica")
    
    # Relationships
    role = relationship("Role", back_populates="users")
    student = relationship("Student", back_populates="user", uselist=False)
    teacher = relationship("Teacher", back_populates="user", uselist=False)
    
    class Config:
        from_attributes = True
