# schemas.py

from pydantic import BaseModel, EmailStr # type: ignore
from typing import Optional

# Import the UserType enum from our database models to reuse it
from .models import UserType

# --- User Schemas ---

# This is the schema for data we expect when a user registers.
# We expect a plain text password.
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    full_name: str
    phone_number: str
    user_type: UserType # Must be 'vet' or 'farmer'

# This is the schema for data we send back when a user is created or requested.
# We NEVER send the password back.
class UserResponse(BaseModel):
    id: int
    email: EmailStr
    full_name: str
    user_type: UserType
    
    # This tells Pydantic to read the data even if it's not a dict,
    # but an ORM model (like our SQLAlchemy User model)
    class Config:
        orm_mode = True


# --- Token Schemas ---

# This is the schema for the response when a user successfully logs in.
class Token(BaseModel):
    access_token: str
    token_type: str

# This is the schema for the data we embed inside the JWT.
class TokenData(BaseModel):
    email: Optional[str] = None

# backend/schemas.py

# ... (keep existing schemas) ...

# --- Vet Schemas ---

class VetProfileResponse(BaseModel):
    qualifications: Optional[str] = None
    vet_council_reg_number: Optional[str] = None

    class Config:
        orm_mode = True

class VetResponse(BaseModel):
    id: int
    full_name: str
    email: EmailStr
    phone_number: str
    vet_profile: Optional[VetProfileResponse] = None

    class Config:
        orm_mode = True