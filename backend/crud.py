# crud.py

from sqlalchemy.orm import Session # type: ignore

# Import our models and schemas so we can use them
from . import models, schemas, security

# --- Read Operations ---

def get_user_by_email(db: Session, email: str):
    """
    Fetches a single user from the database based on their email address.
    """
    return db.query(models.User).filter(models.User.email == email).first()


# --- Create Operations ---

def create_user(db: Session, user: schemas.UserCreate):
    """
    Creates a new user and a corresponding vet profile if the user is a vet.
    """
    # First, hash the plain-text password from the request
    hashed_password = security.get_password_hash(user.password)
    
    # Create the main User database object
    db_user = models.User(
        email=user.email,
        hashed_password=hashed_password,
        full_name=user.full_name,
        phone_number=user.phone_number,
        user_type=user.user_type
    )
    
    # Add the new user to the session and commit it to the database
    db.add(db_user)
    db.commit()
    
    # Refresh the user object to get the new ID assigned by the database
    db.refresh(db_user)

    # If the new user is a vet, we also need to create an empty vet profile for them
    if user.user_type == models.UserType.VET:
        db_vet_profile = models.VetProfile(user_id=db_user.id)
        db.add(db_vet_profile)
        db.commit()
        db.refresh(db_vet_profile)

    return db_user

# backend/crud.py

# ... (keep existing functions) ...

def get_verified_vets(db: Session):
    """
    Fetches all users who are of type 'vet' and are verified.
    """
    return db.query(models.User).filter(
        models.User.user_type == 'vet',
        models.VetProfile.is_verified == True # We only want to show verified vets
    ).join(models.VetProfile).all()

# lib/crud.py

# ... (keep get_user_by_email) ...

def get_user_by_phone_number(db: Session, phone_number: str):
    """
    Fetches a single user from the database based on their phone number.
    """
    return db.query(models.User).filter(models.User.phone_number == phone_number).first()

# ... (keep create_user) ...