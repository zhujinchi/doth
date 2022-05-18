import datetime
from email.utils import quote
import json
from locale import currency
import random
import time
import decimal
from urllib.parse import unquote
from urllib.request import Request
import requests
from flask import Flask, jsonify
from flask import request
from flask import redirect
from flask_sqlalchemy import SQLAlchemy

import my_token
from my_token import auth
import database.my_sqlalchemy as D
import VO.my_response as R
import stripe
from paypalpayoutssdk.payouts import PayoutsPostRequest
from paypalhttp import HttpError, Json
from paypalhttp.encoder import Encoder
from paypalpayoutssdk.core import PayPalHttpClient, SandboxEnvironment
from paypalcheckoutsdk.orders import OrdersCreateRequest
from paypalcheckoutsdk.orders import OrdersCaptureRequest

app = Flask(__name__, static_url_path="", static_folder="/public")
YOUR_DOMAIN = "http://localhost:5050"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///database/test.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config["SQLALCHEMY_ECHO"] = True
db = SQLAlchemy(app)

MY_DOMAIN = "http://1.14.103.90:5000"

# paypal环境 后台
business_address = "doth_test_business@test.com"
client_id = (
    "AU053UWAC0R5AmO_gq6DELT9n7ikP8ljzAUMzQBLOHTl4GuVVnatUXn9_CpT2xIM5qayeqK0YsY-rosW"
)
client_secret = (
    "EA2qKfrCkZkDtPH4x1NUA3nJkuJGiqxJcxkOwu13ve4-s1jf-3w67NM8WYMxvty-XpZy5d0CqX-JFwBf"
)
environment = SandboxEnvironment(client_id=client_id, client_secret=client_secret)
client = PayPalHttpClient(environment)

# paypal环境 公共用户
business_address_pub = "doth_test_business@test.pub"
client_id_pub = (
    "AZP84ChZGra7qnviyFy7tqa3xvlLevnt_4yH0UT7zHM6cj-ph3Ezy6YiRsp166okb8Ocpd5fvG3AQGK2"
)
client_secret_pub = (
    "EE3HMwJEXttReQOV1MklBtC2RQ0Kx67NRxa5hUEP5hsi7C0bNgs3BZVdXcWK5uGPvo06CS3S44kSeV1w"
)
environment_pub = SandboxEnvironment(
    client_id=client_id_pub, client_secret=client_secret_pub
)
client_pub = PayPalHttpClient(environment)


@app.route("/hello")
def hello():
    return "Hello, World!"


@app.route("/register", methods=["POST"])
def register():
    """注册"""
    if request.method == "POST":
        new_user = D.User(
            firstname=request.args["firstname"],
            lastname=request.args["lastname"],
            telephone=request.args["telephone"],
            password=request.args["password"],
            email=request.args["email"],
        )
        db.session.add(new_user)
        try:
            db.session.commit()
        except Exception as e:
            return R.error(msg="注册失败", data=e.args[0])
        return R.ok(msg="注册成功")


@app.route("/login", methods=["POST"])
def login():
    """登录"""
    if request.method == "POST":
        login_user = D.User.query.filter(
            D.User.telephone == request.args["telephone"]
        ).first()
        if login_user is None:
            return R.error(msg="用户不存在")
        if login_user.password == request.args["password"]:
            # JWT token
            token = my_token.create_token(login_user.id)
            return R.ok(msg="登录成功", data="JWT " + token)
        else:
            return R.error(msg="密码错误")


@app.route("/logout", methods=["POST"])
@auth.login_required()
def logout():
    """登出 JWT由客户端负责清除"""
    if request.method == "POST":
        return R.ok(msg="登出成功")


@app.route("/token_test_admin", methods=["POST", "GET"])
@auth.login_required(role="admin")
def token_test_admin():
    """token测试"""
    return R.ok(data="管理员token测试通过")


@app.route("/token_test", methods=["POST", "GET"])
@auth.login_required()
def token_test():
    """token测试"""
    # 拿到当前用户
    this_user = my_token.get_user()
    return R.ok(msg=f"普通用户token测试通过", data=this_user)


@app.route("/paypal_create", methods=["POST"])
@auth.login_required()
def paypal_create():
    """PayPal创建一个交易 之后才能进行抵押转账等操作"""
    amount_usd = request.args["amount_USD"]
    if check_arg_None(amount_usd):
        return R.error(msg="交易额[amount_USD]不能为空")

    user_id = my_token.get_user()["id"]
    new_deal = D.Deal(
        user_id=user_id,
        payout=amount_usd,
        income=0,
        deal_status=0,
        modified_time=datetime.datetime.now(),
        create_time=datetime.datetime.now(),
    )
    db.session.add(new_deal)
    try:
        db.session.commit()
        return R.ok(msg="交易创建成功", data=R.queryToDict(new_deal))
    except Exception as e:
        return R.error(msg="交易创建失败", data=e.args[0])


@app.route("/paypal_list", methods=["GET"])
@auth.login_required()
def paypal_list():
    """查询公共账号下所有的交易记录"""
    user_id = my_token.get_user()["id"]
    deal_list = D.Deal.query.all()
    deal_list = R.queryToDict(deal_list)
    return R.ok(data=deal_list)


@app.route("/paypal_borrow", methods=["POST"])
@auth.login_required()
def paypal_borrow():
    """paypal 用户从后台借款 借款前已完成抵押操作"""
    deal_id = request.args["deal_id"]
    if check_arg_None(deal_id):
        return R.error(msg="交易ID[deal_id]不能为空")
    user_address = business_address_pub
    user_id = my_token.get_user()["id"]
    # 先判断deal_id是否有效
    deal = D.Deal.query.filter(D.Deal.id == deal_id, D.Deal.user_id == user_id).first()
    if deal is None:
        return R.error(msg="交易不存在")
    if deal.deal_status != 0:
        return R.error(msg="交易已放款")
    # 借款金额为创建时后台支出金额
    amount_usd = deal.payout
    amount_usd = str(amount_usd)
    # 用当前时间+随机数设置uuid
    time_str = (
        datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        + "R"
        + str(random.randint(10000, 99999))
    )
    body = {
        "sender_batch_header": {
            "recipient_type": "EMAIL",
            "email_message": "SDK payouts test txn",
            "note": "Enjoy your Payout!",
            "sender_batch_id": time_str,
            "email_subject": "This is a test transaction from SDK",
        },
        "items": [
            {
                "note": "Your Payout",
                "amount": {"currency": "USD", "value": amount_usd},
                "receiver": user_address,
                "sender_item_id": time_str,
            },
        ],
    }
    _request = PayoutsPostRequest()
    _request.request_body(body)
    try:
        response = client.execute(_request)
        batch_id = response.result.batch_header.payout_batch_id
        print("batch_id: " + batch_id)
    except HttpError as httpe:
        encoder = Encoder([Json()])
        error = encoder.deserialize_response(httpe.message, httpe.headers)
        print("Error: " + error["name"])
        print("Error message: " + error["message"])
        print("Information link: " + error["information_link"])
        print("Debug id: " + error["debug_id"])
        print("Details: ")
        for detail in error["details"]:
            print("Error location: " + detail["location"])
            print("Error field: " + detail["field"])
            print("Error issue: " + detail["issue"])
    except IOError as ioe:
        print(ioe.message)
    # 后台记录该次交易
    new_deal_record = D.DealRecord(
        user_id=user_id,
        deal_id=deal_id,
        address_from=business_address,
        address_to=user_address,
        deal_type=-1,
        amount=amount_usd,
        create_time=datetime.datetime.now(),
    )
    db.session.add(new_deal_record)
    # 更新deal状态
    db.session.query(D.Deal).get(deal_id).deal_status = 1
    try:
        db.session.commit()
    except Exception as e:
        return R.error(msg="交易记录失败", data=e.args[0])
    return R.ok(data="借款完成")


@app.route("/paypal_return", methods=["POST", "GET"])
@auth.login_required()
def paypal_return():
    """paypal 用户向后台还款 即支付订单"""
    deal_id = request.args["deal_id"]
    if check_arg_None(deal_id):
        return R.error(msg="交易ID[deal_id]不能为空")
    amount = request.args["amout_USD"]
    if check_arg_None(amount):
        return R.error(msg="还款金额[amout_USD]不能为空")
    user_id = my_token.get_user()["id"]
    # 先判断deal_id是否有效
    deal = (
        db.session.query(D.Deal)
        .filter(D.Deal.id == deal_id, D.Deal.user_id == user_id)
        .first()
    )
    if deal is None:
        return R.error(msg="交易不存在")
    elif deal.deal_status == 0:
        return R.error(msg="交易未放款")
    elif deal.deal_status == 2:
        return R.error(msg="交易已完成")
    elif deal.deal_status == 3:
        return R.error(msg="交易被关闭")
    # 可还金额
    return_max = deal.payout - deal.income
    amount = decimal.Decimal(amount)
    if amount > return_max:
        return R.error(msg=f"高于最高可还金额 {return_max} USD")
    elif amount < 0.01:
        return R.error(msg="低于最低可还金额 0.01 USD")
    # 直接两个写死商户账号转账
    time_str = (
        datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        + "R"
        + str(random.randint(10000, 99999))
    )
    body = {
        "sender_batch_header": {
            "recipient_type": "EMAIL",
            "email_message": "SDK payouts test txn",
            "note": "Enjoy your Payout!",
            "sender_batch_id": time_str,
            "email_subject": "This is a test transaction from SDK",
        },
        "items": [
            {
                "note": "Your Payout",
                "amount": {"currency": "USD", "value": float(amount)},
                "receiver": business_address,
                "sender_item_id": time_str,
            },
        ],
    }
    _request = PayoutsPostRequest()
    _request.request_body(body)
    try:
        response = client_pub.execute(_request)
        batch_id = response.result.batch_header.payout_batch_id
        print("batch_id: " + batch_id)
    except HttpError as httpe:
        encoder = Encoder([Json()])
        error = encoder.deserialize_response(httpe.message, httpe.headers)
        print("Error: " + error["name"])
        print("Error message: " + error["message"])
        print("Information link: " + error["information_link"])
        print("Debug id: " + error["debug_id"])
        print("Details: ")
        for detail in error["details"]:
            print("Error location: " + detail["location"])
            print("Error field: " + detail["field"])
            print("Error issue: " + detail["issue"])
    except IOError as ioe:
        print(ioe.message)
    # 后台记录该次交易
    new_deal_record = D.DealRecord(
        user_id=user_id,
        deal_id=deal_id,
        address_from=business_address_pub,
        address_to=business_address,
        deal_type=1,
        amount=amount,
        create_time=datetime.datetime.now(),
    )
    db.session.add(new_deal_record)
    # 更新deal状态 还齐则完成deal
    db.session.query(D.Deal).get(deal_id).income += amount
    if amount == return_max:
        db.session.query(D.Deal).get(deal_id).deal_status = 2
    db.session.query(D.Deal).get(deal_id).modified_time = datetime.datetime.now()
    try:
        db.session.commit()
    except Exception as e:
        return R.error(msg="交易记录失败", data=e.args[0])
    return R.ok(data=f"还款完成，剩余待还 {return_max-amount} USD")


@app.route("/paypal_wallet", methods=["POST", "GET"])
@auth.login_required()
def paypal_wallet():
    """用户查询公共钱包"""
    sandbox_res = requests.get(
        url="https://api-3t.sandbox.paypal.com/nvp?USER=sb-a4l1y15352147_api1.business.example.com&PWD=UKRD6QGH5JPY2MDK&SIGNATURE=AsNYSFWu0.jD1ZQKfjjNTLzMsHrNABZwBek14F61FVgyYKVWhuwxbhRh&VERSION=109.0&METHOD=GetBalance&RETURNALLCURRENCIES=0"
    )
    # 处理返回值
    res_str = sandbox_res.content.decode()
    print(res_str)
    wallet = {}
    for s in res_str.split('&'):
        if s.startswith('L_AMT0'):
            amount = s[s.index("=")+1:]
            wallet["USD"] = unquote(amount)
    return R.ok(msg="钱包查询成功",data=wallet)


def check_arg_None(_arg):
    """判断参数是否为空"""
    if _arg is None:
        return True
    if type(_arg) is str:
        if _arg == "":
            return True
    return False


db.create_all()
app.run(host="0.0.0.0")
