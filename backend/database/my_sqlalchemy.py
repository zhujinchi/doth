from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_ECHO'] = True
db = SQLAlchemy(app)


class User(db.Model):
    """一般用户表"""
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(64))
    lastname = db.Column(db.String(64))
    telephone = db.Column(db.String(32), unique=True)
    email = db.Column(db.String(128), unique=True)
    password = db.Column(db.String(128))
    address = db.Column(db.String(256), nullable=True)  # 地址 预留字段

    def __repr__(self):
        """打印非下划线开头的属性"""
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class Admin(db.Model):
    """管理员用户表"""
    id = db.Column(db.Integer, primary_key=True)
    adminname = db.Column(db.String(64), unique=True)
    email = db.Column(db.String(128), unique=True)
    password = db.Column(db.String(128))
    address = db.Column(db.String(256), nullable=True)  # 地址 预留字段

    def __repr__(self):
        """打印非下划线开头的属性"""
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class Wallet(db.Model):
    """钱包表"""
    id = db.Column(db.Integer, primary_key=True)
    address = db.Column(db.String(256), unique=True)

    def __repr__(self):
        """打印非下划线开头的属性"""
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])


class DealRecord(db.Model):
    """交易记录表 一次交易可能有多次记录"""
    id = db.Column(db.Integer, primary_key=True)
    deal_id = db.Column(db.Integer)  # 对应的交易id
    user_id = db.Column(db.Integer)  # 用户id
    address_from = db.Column(db.String(256))
    address_to = db.Column(db.String(256))
    deal_type = db.Column(db.Integer)  # 交易种类 -1->支出，借给用户 1->收入，用户还款
    amount = db.Column(db.DECIMAL(16,2))  # 交易数额 美元
    note = db.Column(db.String(256),nullable=True)  # 记录信息
    create_time = db.Column(db.DateTime)  # 交易时间

    def __repr__(self):
        """打印非下划线开头的属性"""
        return str([item for item in self.__dict__.items() if not item[0].startswith("_")])

class Deal(db.Model):
    """交易表"""
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)  # 用户id
    payout = db.Column(db.DECIMAL(16,2))  # 后台总支出数额 美元
    income = db.Column(db.DECIMAL(16,2))  # 后台总收入数额 美元
    deal_status = db.Column(db.Integer)  # 交易状态 0->进行中 1->已放款 2->已完成 3->被关闭
    create_time = db.Column(db.DateTime)  # 交易创建时间
    modified_time = db.Column(db.DateTime)  # 交易更新时间

class Order(db.Model):
    """账单表 PayPal确认"""
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)  # 用户id
    # user_paypal_id = db.Column(db.String(64))  # 用户的PayPalID
    order_id = db.Column(db.String(64))  # paypal 订单ID
    link_url = db.Column(db.String(256))  # 浏览器端的url
    order_status = db.Column(db.Integer)  # 交易状态 0->进行中 1->已完成
    create_time = db.Column(db.DateTime)  # 交易创建时间
    modified_time = db.Column(db.DateTime)  # 交易更新时间


if __name__ == '__main__':
    db.drop_all()
    db.create_all()
