# import datetime
# import json
# import random
# import time
# from unicodedata import decimal

# from flask import Flask, jsonify
# from flask import request
# from flask import redirect
# from flask_sqlalchemy import SQLAlchemy

# import my_token
# from my_token import auth
# import database.my_sqlalchemy as D
# import VO.my_response as R
# import stripe
# from paypalpayoutssdk.payouts import PayoutsPostRequest
# from paypalhttp import HttpError, Json
# from paypalhttp.encoder import Encoder
# from paypalpayoutssdk.core import PayPalHttpClient, SandboxEnvironment
# from paypalcheckoutsdk.orders import OrdersCreateRequest
# from paypalcheckoutsdk.orders import OrdersCaptureRequest

# app = Flask(__name__, static_url_path="", static_folder="/public")
# YOUR_DOMAIN = "http://localhost:5050"

# app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///database/test.db"
# app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
# app.config["SQLALCHEMY_ECHO"] = True
# db = SQLAlchemy(app)

# MY_DOMAIN = 'http://1.14.103.90:5000'

# # paypal环境 后台
# business_address = "doth_test_business@test.com"
# client_id = (
#     "AU053UWAC0R5AmO_gq6DELT9n7ikP8ljzAUMzQBLOHTl4GuVVnatUXn9_CpT2xIM5qayeqK0YsY-rosW"
# )
# client_secret = (
#     "EA2qKfrCkZkDtPH4x1NUA3nJkuJGiqxJcxkOwu13ve4-s1jf-3w67NM8WYMxvty-XpZy5d0CqX-JFwBf"
# )
# environment = SandboxEnvironment(client_id=client_id, client_secret=client_secret)
# client = PayPalHttpClient(environment)

# # paypal环境 公共用户
# business_address_pub = "doth_test_business@test.pub"
# client_id_pub = (
#     "AZP84ChZGra7qnviyFy7tqa3xvlLevnt_4yH0UT7zHM6cj-ph3Ezy6YiRsp166okb8Ocpd5fvG3AQGK2"
# )
# client_secret_pub = (
#     "EE3HMwJEXttReQOV1MklBtC2RQ0Kx67NRxa5hUEP5hsi7C0bNgs3BZVdXcWK5uGPvo06CS3S44kSeV1w"
# )
# environment_pub = SandboxEnvironment(client_id=client_id_pub, client_secret=client_secret_pub)
# client_pub = PayPalHttpClient(environment)

# @app.route("/hello")
# def hello():
#     return "Hello, World!"


# @app.route("/register", methods=["POST"])
# def register():
#     """注册"""
#     if request.method == "POST":
#         new_user = D.User(
#             firstname=request.args["firstname"],
#             lastname=request.args["lastname"],
#             telephone=request.args["telephone"],
#             password=request.args["password"],
#             email=request.args["email"],
#         )
#         db.session.add(new_user)
#         try:
#             db.session.commit()
#         except Exception as e:
#             return R.error(msg="注册失败", data=e.args[0])
#         return R.ok(msg="注册成功")


# @app.route("/login", methods=["POST"])
# def login():
#     """登录"""
#     if request.method == "POST":
#         login_user = D.User.query.filter(
#             D.User.telephone == request.args["telephone"]
#         ).first()
#         if login_user is None:
#             return R.error(msg="用户不存在")
#         if login_user.password == request.args["password"]:
#             # JWT token
#             token = my_token.create_token(login_user.id)
#             return R.ok(msg="登录成功", data="JWT " + token)
#         else:
#             return R.error(msg="密码错误")


# @app.route("/logout", methods=["POST"])
# @auth.login_required()
# def logout():
#     """登出 JWT由客户端负责清除"""
#     if request.method == "POST":
#         return R.ok(msg="登出成功")


# @app.route("/token_test_admin", methods=["POST", "GET"])
# @auth.login_required(role="admin")
# def token_test_admin():
#     """token测试"""
#     return R.ok(data="管理员token测试通过")


# @app.route("/token_test", methods=["POST", "GET"])
# @auth.login_required()
# def token_test():
#     """token测试"""
#     # 拿到当前用户
#     this_user = my_token.get_user()
#     return R.ok(msg=f"普通用户token测试通过", data=this_user)

# @app.route("/paypal_create", methods=["POST"])
# @auth.login_required()
# def paypal_create():
#     """PayPal创建一个交易 之后才能进行抵押转账等操作"""
#     amount_usd = request.args["amount_USD"]
#     if check_arg_None(amount_usd):
#         return R.error(msg="交易额[amount_USD]不能为空")

#     user_id = my_token.get_user()["id"]
#     new_deal = D.Deal(
#         user_id=user_id,
#         payout=amount_usd,
#         income=0,
#         deal_status=0,
#         modified_time=datetime.datetime.now(),
#         create_time=datetime.datetime.now(),
#     )
#     db.session.add(new_deal)
#     try:
#         db.session.commit()
#         return R.ok(msg="交易创建成功")
#     except Exception as e:
#         return R.error(msg="交易创建失败", data=e.args[0])


# @app.route("/paypal_list", methods=["GET"])
# @auth.login_required()
# def paypal_list():
#     """查询用户名下所有的交易"""
#     user_id = my_token.get_user()["id"]
#     deal_list = D.Deal.query.filter(D.Deal.user_id == user_id).all()
#     deal_list = R.queryToDict(deal_list)
#     return R.ok(data=deal_list)


# @app.route("/paypal_borrow", methods=["POST"])
# @auth.login_required()
# def paypal_borrow():
#     """paypal 用户从后台借款 借款前已完成抵押操作"""
#     deal_id = request.args["deal_id"]
#     if check_arg_None(deal_id):
#         return R.error(msg="交易ID[deal_id]不能为空")
#     # amount_usd = request.args['amount_USD']
#     # if check_arg_None(amount_usd): return R.error(msg="交易额[amount_USD]不能为空")
#     user_address = request.args["address"]
#     if check_arg_None(user_address):
#         return R.error(msg="用户PayPal地址[address]不能为空")
#     user_id = my_token.get_user()["id"]
#     # 先判断deal_id是否有效
#     deal = D.Deal.query.filter(D.Deal.id == deal_id, D.Deal.user_id == user_id).first()
#     if deal is None:
#         return R.error(msg="交易不存在")
#     if deal.deal_status != 0:
#         return R.error(msg="交易已放款")
#     # 借款金额为创建时后台支出金额
#     amount_usd = deal.payout
#     amount_usd = str(amount_usd)
#     # 用当前时间+随机数设置uuid
#     time_str = (
#         datetime.datetime.now().strftime("%Y%m%d%H%M%S")
#         + "R"
#         + str(random.randint(10000, 99999))
#     )
#     body = {
#         "sender_batch_header": {
#             "recipient_type": "EMAIL",
#             "email_message": "SDK payouts test txn",
#             "note": "Enjoy your Payout!!",
#             "sender_batch_id": time_str,
#             "email_subject": "This is a test transaction from SDK",
#         },
#         "items": [
#             {
#                 "note": "Your Payout",
#                 "amount": {"currency": "USD", "value": amount_usd},
#                 "receiver": user_address,
#                 "sender_item_id": time_str,
#             },
#         ],
#     }
#     _request = PayoutsPostRequest()
#     _request.request_body(body)
#     try:
#         response = client.execute(_request)
#         batch_id = response.result.batch_header.payout_batch_id
#         print("batch_id: " + batch_id)
#     except HttpError as httpe:
#         encoder = Encoder([Json()])
#         error = encoder.deserialize_response(httpe.message, httpe.headers)
#         print("Error: " + error["name"])
#         print("Error message: " + error["message"])
#         print("Information link: " + error["information_link"])
#         print("Debug id: " + error["debug_id"])
#         print("Details: ")
#         for detail in error["details"]:
#             print("Error location: " + detail["location"])
#             print("Error field: " + detail["field"])
#             print("Error issue: " + detail["issue"])
#     except IOError as ioe:
#         print(ioe.message)
#     # 后台记录该次交易
#     new_deal_record = D.DealRecord(
#         user_id=user_id,
#         deal_id=deal_id,
#         address_from=business_address,
#         address_to=user_address,
#         deal_type=-1,
#         amount=amount_usd,
#         create_time=datetime.datetime.now(),
#     )
#     db.session.add(new_deal_record)
#     # 更新deal状态
#     db.session.query(D.Deal).get(deal_id).deal_status = 1
#     try:
#         db.session.commit()
#     except Exception as e:
#         return R.error(msg="交易记录失败", data=e.args[0])
#     return R.ok(data="借款完成")


# @app.route("/paypal_return", methods=["POST", "GET"])
# @auth.login_required()
# def paypal_return():
#     """paypal 用户向后台还款 即支付订单"""
#     deal_id = request.args["deal_id"]
#     if check_arg_None(deal_id):
#         return R.error(msg="交易ID[deal_id]不能为空")
#     amount = request.args["amout_USD"]
#     if check_arg_None(amount):
#         return R.error(msg="还款金额[amout_USD]不能为空")
#     user_id = my_token.get_user()["id"]
#     # 先判断deal_id是否有效
#     deal = (
#         db.session.query(D.Deal)
#         .filter(D.Deal.id == deal_id, D.Deal.user_id == user_id)
#         .first()
#     )
#     if deal is None:
#         return R.error(msg="交易不存在")
#     elif deal.deal_status == 0:
#         return R.error(msg="交易未放款")
#     elif deal.deal_status == 2:
#         return R.error(msg="交易已完成")
#     elif deal.deal_status == 3:
#         return R.error(msg="交易被关闭")
#     # 可还金额
#     return_max = deal.payout - deal.income
#     amount = float(amount)
#     if amount > return_max:
#         return R.error(msg="高于最高可还金额")
#     elif amount < 0.01:
#         return R.error(msg="低于最低可还金额")
#     # 创建账单
#     _request = OrdersCreateRequest()
#     _request.prefer("return=representation")
#     _request.request_body(
#         {
#             "intent": "CAPTURE",
#             "application_context": {
#                 "return_url": MY_DOMAIN+"/paypal_success",
#                 "cancel_url": "https://www.example.com",
#                 "brand_name": "Doth",
#                 "landing_page": "BILLING",
#                 "shipping_preference": "SET_PROVIDED_ADDRESS",
#                 "user_action": "PAY_NOW",
#             },
#             "purchase_units": [
#                 {
#                     "reference_id": "PUHF",
#                     "description": "Sporting Goods",
#                     "custom_id": "CUST-HighFashions",
#                     "soft_descriptor": "HighFashions",
#                     "amount": {
#                         "currency_code": "USD",
#                         "value": "220.00",
#                         "breakdown": {
#                             "item_total": {"currency_code": "USD", "value": "180.00"},
#                             "shipping": {"currency_code": "USD", "value": "20.00"},
#                             "handling": {"currency_code": "USD", "value": "10.00"},
#                             "tax_total": {"currency_code": "USD", "value": "20.00"},
#                             "shipping_discount": {
#                                 "currency_code": "USD",
#                                 "value": "10",
#                             },
#                         },
#                     },
#                     "items": [
#                         {
#                             "name": "T-Shirt",
#                             "description": "Green XL",
#                             "sku": "sku01",
#                             "unit_amount": {"currency_code": "USD", "value": "90.00"},
#                             "tax": {"currency_code": "USD", "value": "10.00"},
#                             "quantity": "1",
#                             "category": "PHYSICAL_GOODS",
#                         },
#                         {
#                             "name": "Shoes",
#                             "description": "Running, Size 10.5",
#                             "sku": "sku02",
#                             "unit_amount": {"currency_code": "USD", "value": "45.00"},
#                             "tax": {"currency_code": "USD", "value": "5.00"},
#                             "quantity": "2",
#                             "category": "PHYSICAL_GOODS",
#                         },
#                     ],
#                     "shipping": {
#                         "method": "United States Postal Service",
#                         "name": {"full_name": "John Doe"},
#                         "address": {
#                             "address_line_1": "123 Townsend St",
#                             "address_line_2": "Floor 6",
#                             "admin_area_2": "San Francisco",
#                             "admin_area_1": "CA",
#                             "postal_code": "94107",
#                             "country_code": "US",
#                         },
#                     },
#                 }
#             ],
#         }
#     )
#     try:
#         response = client.execute(_request)
#         print("Order With Complete Payload:")
#         print("Status Code:", response.status_code)
#         print("Status:", response.result.status)
#         print("Order ID:", response.result.id)
#         print("Intent:", response.result.intent)
#         print("Links:")
#         for link in response.result.links:
#             print("\t{}: {}\tCall Type: {}".format(link.rel, link.href, link.method))
#             print(
#                 "Total Amount: {} {}".format(
#                     response.result.purchase_units[0].amount.currency_code,
#                     response.result.purchase_units[0].amount.value,
#                 )
#             )
#         # If call returns body in response, you can get the deserialized version from the result attribute of the response
#         order = response.result
#         print(order)
#         # 存入PayPal账单表
#         new_order = D.Order(
#             user_id=user_id,
#             order_id=order['id'],
#             link_url=order['links'][1]['href'],
#             order_status=0,
#             create_time=datetime.datetime.now(),
#             modified_time=datetime.datetime.now(),
#         )
#         db.session.add(new_order)
#     except IOError as ioe:
#         print(ioe)
#         if isinstance(ioe, HttpError):
#             print(ioe.status_code)
#     return R.ok(data=order['links'][1]['href'])

# @app.route("/paypal_success", methods=["GET"])
# def paypal_success():
#     """捕获PayPal的账单以完成支付"""
#     token = request.args["token"]
#     if check_arg_None(token):
#         return R.error(msg="交易ID[deal_id]不能为空")
#     _request = OrdersCaptureRequest(token)
#     try:
#         response = client.execute(_request)
#         order = response.result.id
#         # 后台记录该次交易
#         new_deal_record = D.DealRecord(
#             user_id=user_id,
#             deal_id=deal_id,
#             address_from=business_address,
#             address_to=user_address,
#             deal_type=-1,
#             amount=amount_usd,
#             create_time=datetime.datetime.now(),
#         )
#         db.session.add(new_deal_record)
#         # 更新deal状态
#         db.session.query(D.Deal).get(deal_id).deal_status = 1
#         try:
#             db.session.commit()
#         except Exception as e:
#             return R.error(msg="交易记录失败", data=e.args[0])
#         return R.ok(data="借款完成")
#     except IOError as ioe:
#         print(ioe)

# def check_arg_None(_arg):
#     """判断参数是否为空"""
#     if _arg is None:
#         return True
#     if type(_arg) is str:
#         if _arg == "":
#             return True
#     return False


# db.create_all()
# app.run(host="0.0.0.0")
