from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)


# 数据库配置
class Config(object):
    """配置参数"""
    # sqlalchemy的配置参数
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/doth_database.db'

    # 设置sqlalchemy自动更新跟踪数据库
    SQLALCHEMY_TRACK_MODIFICATIONS = True


# 将配置连接到数据库
app.config.from_object(Config)

# 创建数据库alchemy工具对象
db = SQLAlchemy(app)


# 创建数据库用户类
class User(db.model):
    """用户表"""
    __tablename__ = "doth_users"  # 指明数据库的表名

    user_id = db.Column(db.Integer, primary_key=True)  # 整型的主键，会默认设置为自增主键
    user_name = db.Column(db.String(64), unique=True)
    user_email = db.Column(db.String(128), unique=True)
    user_password = db.Column(db.String(128))
    # role = db.Colum(db.Int(4))



# 创建数据库钱包类
class Wallet(db.model):
    """钱包表"""
    __tablename__ = "doth_wallet"

    wallet_id = db.Column(db.Integer, primary_key=True)  # 整型的主键，会默认设置为自增主键
    wallet_address = db.Column(db.String(128), unique=True)  # 不知道要不要设置成unique


# 创建数据库管理员类 用户后台管理系统的登陆和认证
class Manager(db.model):
    """管理员表"""
    __tablename__ = "doth_manager"

    manager_id = db.Column(db.Integer, primary_key=True)  # 整型的主键，会默认设置为自增主键
    manager_password = password = db.Column(db.String(128))


# 创建交易类
class Deal(db.model):
    """管理员表"""
    __tablename__ = "doth_deal"

    deal_id = db.Column(db.Integer, primary_key=True)  # 整型的主键，会默认设置为自增主键
    wallet_address = wallet_address = db.Column(db.String(128), unique=True) # 不知道要不要设置成unique
