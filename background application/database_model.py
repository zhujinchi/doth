# pip install flask-sqlalchemy
from flask_sqlalchemy import SQLAlchemy
from flask import Flask

app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123456@127.0.0.1:3306/test'

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + "/home/lmp/test.db"

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'xxx'
db = SQLAlchemy(app)


# 用户表
class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)  # id号(独一无二的)
    name = db.Column(db.String(64), nullable=False)  # 姓名
    gender = db.Column(db.Enum("男", "女"), nullable=False)  # 性别
    phone = db.Column(db.String(11), unique=True, nullable=False)  # 手机号
    wallets = db.relationship("wallet", secondary="user_wallet", backref="users")  # 关系关联
    moneys = db.relationship("money", backref="user")  # 关系关联


# 用户-钱包中间表
class UserWallet(db.Model):
    __tablename__ = "user_wallet"
    id = db.Column(db.Integer, primary_key=True)  # id号(独一无二的)
    users_id = db.Column(db.Integer, db.ForeignKey("user.id"))  # 用户的id
    wallets_id = db.Column(db.Integer, db.ForeignKey("wallet.id"))  # 钱包的id


# 钱包表
class Wallet(db.Model):
    __tablename__ = "wallet"
    id = db.Column(db.Integer, primary_key=True)  # id号(独一无二的)
    name = db.Column(db.String(32), unique=True)  # 钱包名字
    manager_id = db.Column(db.Integer, db.ForeignKey("manager.id"))  # 所属老师的id
    moneys = db.relationship("money", backref="wallet")  # 余额关系关联


# 管理员表
class Manager(db.Model):
    __tablename__ = "manager"
    id = db.Column(db.Integer, primary_key=True)  # id号(独一无二的)
    name = db.Column(db.String(32), unique=True)  # 姓名
    phone = db.Column(db.String(11), unique=True, nullable=False)  # 手机号
    gender = db.Column(db.Enum("男", "女"), nullable=False)  # 性别
    wallet = db.relationship("wallet", backref="manager")  # 所管钱包


# 余额表
class Money(db.Model):
    __tablename__ = "money"
    id = db.Column(db.Integer, primary_key=True)  # id号(独一无二的)
    my_money = db.Column(db.String(32), unique=True)  # 钱
    wallet_id = db.Column(db.Integer, db.ForeignKey("wallet.id"))  # 所属钱包
    users_id = db.Column(db.Integer, db.ForeignKey("user.id"))  # 所属用户


if __name__ == "__main__":
    db.create_all()
    # db.drop_all()