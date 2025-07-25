# security.py

from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt # type: ignore
from passlib.context import CryptContext # type: ignore
from fastapi import Depends, HTTPException, status # type: ignore # <-- Add HTTPException, status
from fastapi.security import OAuth2PasswordBearer # type: ignore # <-- Add this
from sqlalchemy.orm import Session # type: ignore # <-- Add this
from . import crud, models # <-- Add this
from .database import get_db
from .database import SessionLocal # <-- Add this
from .schemas import TokenData # <-- Add this
from decouple import config # type: ignore

# Load our secret settings from the .env file
SECRET_KEY = config("SECRET_KEY")
ALGORITHM = config("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = int(config("ACCESS_TOKEN_EXPIRE_MINUTES"))

# --- Password Hashing Setup ---

# This tells passlib what hashing algorithm to use. bcrypt is a strong standard.
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Function to verify a plain password against a hashed one
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# Function to hash a plain password
def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


# --- JWT Token Creation ---

# Function to create a new access token
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    
    # Set the expiration time for the token
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    
    # Encode the token with our data, secret key, and algorithm
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    
    return encoded_jwt

# This tells FastAPI where to look for the token (in the 'Authorization' header)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

# --- NEW: Function to get current user from token ---
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except JWTError:
        raise credentials_exception
    
    user = crud.get_user_by_email(db, email=token_data.email)
    if user is None:
        raise credentials_exception
    return user