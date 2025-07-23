# security.py

from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt # type: ignore
from passlib.context import CryptContext # type: ignore
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