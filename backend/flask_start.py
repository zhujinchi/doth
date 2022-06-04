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
import event_listener 

app = Flask(__name__, static_url_path="")

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///database/test.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config["SQLALCHEMY_ECHO"] = True
db = SQLAlchemy(app)

MY_DOMAIN = "http://1.14.103.90:5000"

# paypal Config back end
business_address = "doth_test_business@test.com"
client_id = (
    "AU053UWAC0R5AmO_gq6DELT9n7ikP8ljzAUMzQBLOHTl4GuVVnatUXn9_CpT2xIM5qayeqK0YsY-rosW"
)
client_secret = (
    "EA2qKfrCkZkDtPH4x1NUA3nJkuJGiqxJcxkOwu13ve4-s1jf-3w67NM8WYMxvty-XpZy5d0CqX-JFwBf"
)
environment = SandboxEnvironment(client_id=client_id, client_secret=client_secret)
client = PayPalHttpClient(environment)

# paypal Config public_wallet
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
client_pub = PayPalHttpClient(environment_pub)


@app.route("/hello")
def hello():
    return "Hello, World!"


@app.route("/register", methods=["POST"])
def register():
    """register"""
    if request.method == "POST":
        new_user = D.User(
            firstname=request.args["firstname"],
            lastname=request.args["lastname"],
            telephone=request.args["telephone"],
            password=request.args["password"],
            email=request.args["email"],
            public_key=request.args['public_key']
        )
        db.session.add(new_user)
        try:
            db.session.commit()
        except Exception as e:
            return R.error(msg="Register Fail", data=e.args[0])
        return R.ok(msg="Register Success")


@app.route("/login", methods=["POST"])
def login():
    """Login"""
    if request.method == "POST":
        login_user = db.session.query(D.User).filter(
            D.User.email == request.args["email"]
        ).first()
        if login_user is None:
            return R.error(msg="User Not Found")
        if login_user.password == request.args["password"]:
            # JWT token
            token = my_token.create_token(login_user.id)
            return R.ok(msg="Login Success", data={"token":"JWT " + token, "public_key":login_user.public_key, "user":R.queryToDict(login_user)})
        else:
            return R.error(msg="Password Incorrect")


@app.route("/logout", methods=["POST"])
@auth.login_required()
def logout():
    """logout"""
    if request.method == "POST":
        return R.ok()


@app.route("/token_test_admin", methods=["POST", "GET"])
@auth.login_required(role="admin")
def token_test_admin():
    """token test"""
    return R.ok(data="admin token test pass")


@app.route("/token_test", methods=["POST", "GET"])
@auth.login_required()
def token_test():
    """token test"""
    # get current user
    this_user = my_token.get_user()
    return R.ok(msg=f"user token test pass", data=this_user)


@app.route("/paypal_create", methods=["POST"])
@auth.login_required()
def paypal_create():
    """PayPal create a deal"""
    amount_usd = request.args["amount_USD"]
    if check_arg_None(amount_usd):
        return R.error(msg="[amount_USD] can not be null")

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
        return R.ok(msg="Deal Create Success", data=R.queryToDict(new_deal))
    except Exception as e:
        return R.error(msg="Deal Create Fail", data=e.args[0])


@app.route("/paypal_list", methods=["GET"])
@auth.login_required()
def paypal_list():
    """query all deal records of the public wallet"""
    user_id = my_token.get_user()["id"]
    deal_list = D.Deal.query.all()
    deal_list = R.queryToDict(deal_list)
    return R.ok(data=deal_list)


@app.route("/paypal_borrow", methods=["POST"])
@auth.login_required()
def paypal_borrow():
    """user borrow"""
    deal_id = request.args["deal_id"]
    if check_arg_None(deal_id):
        return R.error(msg="[deal_id] can not be null")
    user_address = business_address_pub
    user_id = my_token.get_user()["id"]
    # varify deal
    deal = D.Deal.query.filter(D.Deal.id == deal_id, D.Deal.user_id == user_id).first()
    if deal is None:
        return R.error(msg="Deal Not Found")
    if deal.deal_status != 0:
        return R.error(msg="Deal Has Been Loan")
    amount_usd = deal.payout
    amount_usd = str(amount_usd)
    # make paypal item uuid
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
        return R.error(msg=error)
    except IOError as ioe:
        return R.error(msg=ioe.message)
    # insert this deal
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
    # update this deal status
    db.session.query(D.Deal).get(deal_id).deal_status = 1
    try:
        db.session.commit()
    except Exception as e:
        return R.error(msg="Deal insert fail", data=e.args[0])
    return R.ok(data="Borrow Success")


@app.route("/paypal_return", methods=["POST", "GET"])
@auth.login_required()
def paypal_return():
    """paypal repaying the loan"""
    deal_id = request.args["deal_id"]
    if check_arg_None(deal_id):
        return R.error(msg="[deal_id] can not be null")
    amount = request.args["amount_USD"]
    if check_arg_None(amount):
        return R.error(msg="[amount_USD] can not be null")
    user_id = my_token.get_user()["id"]
    # verify deal_id
    deal = (
        db.session.query(D.Deal)
        .filter(D.Deal.id == deal_id, D.Deal.user_id == user_id)
        .first()
    )
    if deal is None:
        return R.error(msg="Deal not found")
    elif deal.deal_status == 0:
        return R.error(msg="Deal ")
    elif deal.deal_status == 2:
        return R.error(msg="Deal is Done")
    elif deal.deal_status == 3:
        return R.error(msg="Deal is closed")
    # user repay max
    return_max = deal.payout - deal.income
    amount = decimal.Decimal(amount)
    if amount > return_max:
        return R.error(msg=f"Above the max {return_max} USD")
    elif amount < 0.01:
        return R.error(msg="Below the min 0.01 USD")
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
    # insert this deal
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
    # update this deal, make it done if the rest is 0
    db.session.query(D.Deal).get(deal_id).income += amount
    if amount == return_max:
        db.session.query(D.Deal).get(deal_id).deal_status = 2
    db.session.query(D.Deal).get(deal_id).modified_time = datetime.datetime.now()
    try:
        db.session.commit()
    except Exception as e:
        return R.error(msg="Deal insert fail", data=e.args[0])
    return R.ok(data=f"Repay success, {return_max-amount} USD remaining")


@app.route("/paypal_wallet", methods=["POST", "GET"])
@auth.login_required()
def paypal_wallet():
    """query amount of the public wallet"""
    sandbox_res = requests.get(
        url="https://api-3t.sandbox.paypal.com/nvp?USER=sb-a4l1y15352147_api1.business.example.com&PWD=UKRD6QGH5JPY2MDK&SIGNATURE=AsNYSFWu0.jD1ZQKfjjNTLzMsHrNABZwBek14F61FVgyYKVWhuwxbhRh&VERSION=109.0&METHOD=GetBalance&RETURNALLCURRENCIES=0"
    )
    # response process
    res_str = sandbox_res.content.decode()
    print(res_str)
    wallet = {}
    for s in res_str.split('&'):
        if s.startswith('L_AMT0'):
            amount = s[s.index("=")+1:]
            wallet["USD"] = unquote(amount)
    return R.ok(data=wallet)


def check_arg_None(_arg):
    """return True if the argument is none or empty"""
    if _arg is None:
        return True
    if type(_arg) is str:
        if _arg == "":
            return True
    return False

@app.route("/get_email", methods=["POST", "GET"])
def getEmailByAddress():
    """get user email from database"""
    user_address = request.args["user_address"]
    login_user = db.session.query(D.User).filter(D.User.public_key.like(user_address)).first()
    user_email = login_user.email
    return user_email

db.create_all()
event_listener.event_listener_start()
app.run(host="0.0.0.0")

