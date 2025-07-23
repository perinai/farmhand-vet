# models.py

import enum
from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, Enum as SQLAlchemyEnum, Text, ForeignKey, DateTime # type: ignore
from sqlalchemy.orm import relationship # type: ignore

# Import the Base from our database file
from .database import Base

class UserType(str, enum.Enum):
    FARMER = "farmer"
    VET = "vet"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    user_type = Column(SQLAlchemyEnum(UserType), nullable=False)
    full_name = Column(String)
    phone_number = Column(String, unique=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # This creates the link to the VetProfile
    vet_profile = relationship("VetProfile", back_populates="user", uselist=False, cascade="all, delete-orphan")

class VetProfile(Base):
    __tablename__ = "vet_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    qualifications = Column(Text, nullable=True)
    vet_council_reg_number = Column(String, unique=True, nullable=True)
    is_verified = Column(Boolean, default=False)
    
    # This creates the link back to the User
    user = relationship("User", back_populates="vet_profile")