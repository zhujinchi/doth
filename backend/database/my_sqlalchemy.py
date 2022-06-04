from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_ECHO'] = True
db = SQLAlchemy(app)


class User(db.Model):
    """User table"""
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(64))
    lastname = db.Column(db.String(64))
    telephone = db.Column(db.String(32), unique=True)
    email = db.Column(db.String(128), unique=True)
    password = db.Column(db.String(128))
    public_key = db.Column(db.String(256))  # public_key

    def __repr__(self):
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class Admin(db.Model):
    """Admin table"""
    id = db.Column(db.Integer, primary_key=True)
    adminname = db.Column(db.String(64), unique=True)
    email = db.Column(db.String(128), unique=True)
    password = db.Column(db.String(128))
    address = db.Column(db.String(256), nullable=True)  # reserved field

    def __repr__(self):
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class Wallet(db.Model):
    """Wallet table"""
    id = db.Column(db.Integer, primary_key=True)
    address = db.Column(db.String(256), unique=True)

    def __repr__(self):
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class DealRecord(db.Model):
    """Deal records table"""
    id = db.Column(db.Integer, primary_key=True)
    deal_id = db.Column(db.Integer)
    user_id = db.Column(db.Integer)
    address_from = db.Column(db.String(256))
    address_to = db.Column(db.String(256))
    deal_type = db.Column(db.Integer)  # -1->payout 1->income
    amount = db.Column(db.DECIMAL(16,2))  # unit USD
    note = db.Column(db.String(256),nullable=True)
    create_time = db.Column(db.DateTime)

    def __repr__(self):
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])

class Deal(db.Model):
    """Deal table"""
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    payout = db.Column(db.DECIMAL(16,2))  # background payout, user borrow, USD
    income = db.Column(db.DECIMAL(16,2))  # background income, user repay, USD
    deal_status = db.Column(db.Integer)  # 0->ongoing 1->loaned 2->done 3->closed
    create_time = db.Column(db.DateTime)
    modified_time = db.Column(db.DateTime)


if __name__ == '__main__':
    db.drop_all()
    db.create_all()
