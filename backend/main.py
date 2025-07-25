# main.py

from fastapi import FastAPI, Depends, HTTPException, status # type: ignore
from fastapi.security import OAuth2PasswordRequestForm # type: ignore
from sqlalchemy.orm import Session # type: ignore
from typing import List

# Import all our modules so we can use their functions
from . import crud, models, schemas, security
from .database import SessionLocal, engine, get_db

# This line tells SQLAlchemy to create all the tables defined in models.py
# in our database. If they already exist, it does nothing.
models.Base.metadata.create_all(bind=engine)

# Initialize our FastAPI application
app = FastAPI(title="VetLig API")


# --- Dependency ---
# This is a special function that FastAPI will run for every request that needs it.
# It creates a new database session for that single request and makes sure
# it's closed when the request is finished.



# --- API Endpoints ---

# lib/main.py

@app.post("/auth/register", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED, tags=["Authentication"])
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Check if email exists
    db_user_by_email = crud.get_user_by_email(db, email=user.email)
    if db_user_by_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered",
        )
    
    # --- NEW CODE: Check if phone number exists ---
    db_user_by_phone = crud.get_user_by_phone_number(db, phone_number=user.phone_number)
    if db_user_by_phone:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Phone number already registered",
        )
    # --- END OF NEW CODE ---
    
    new_user = crud.create_user(db=db, user=user)
    return new_user


@app.post("/auth/login", response_model=schemas.Token, tags=["Authentication"])
def login_for_access_token(db: Session = Depends(get_db), form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Log in a user.
    - Takes email in the 'username' field.
    - Verifies the user and password.
    - Returns a JWT access token.
    """
    # FastAPI's form_data uses 'username', but we are using email.
    user = crud.get_user_by_email(db, email=form_data.username)
    
    # Verify the user exists and the password is correct
    if not user or not security.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    # Create the access token for the user
    access_token = security.create_access_token(
        data={"sub": user.email}
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/vets", response_model=List[schemas.VetResponse], tags=["Vets"])
def read_vets(db: Session = Depends(get_db)):
    """
    Retrieve all verified veterinarians.
    """
    vets = crud.get_verified_vets(db)
    return vets

# --- Users Endpoints ---

@app.get("/users/me", response_model=schemas.UserResponse, tags=["Users"])
def read_users_me(current_user: models.User = Depends(security.get_current_user)):
    """
    Get the profile of the currently logged-in user.
    """
    return current_user