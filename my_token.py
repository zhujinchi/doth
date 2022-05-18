import functools

from flask import request
from flask_httpauth import HTTPTokenAuth, make_response
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired
import VO.my_response as R

auth = HTTPTokenAuth(scheme='JWT')

# 私钥 最好单独存储
SECRET_KEY = "2bf9fdb6-d94c-4942-b383-2e116f6de7c7"


@auth.verify_token
def verify_token(token):
    """token校验"""
    s = Serializer(SECRET_KEY)
    try:
        data = s.loads(token)
    except BadSignature:
        print("token错误")
        return False
    except SignatureExpired:
        print("token过期")
        return False
    return True


@auth.error_handler
def errortoken_auth():
    return make_response(R.error(msg="token错误或过期"), 401)


@auth.get_user_roles
def get_user_roles(token):
    """token鉴权"""
    # 拿到实际token值而非对象
    token = token['token']
    s = Serializer(SECRET_KEY)
    try:
        user = s.loads(token)
        return user["role"]
    except Exception as e:
        return None


def create_token(user_id, role="user"):
    """token生成 默认为普通用户"""
    s = Serializer(SECRET_KEY, expires_in=3600)
    token = s.dumps({"id": user_id, "role": role}).decode('ascii')
    return token


def get_user():
    """从token中获取用户ID"""
    token = auth.get_auth()['token']
    s = Serializer(SECRET_KEY)
    try:
        user = s.loads(token)
        return user

    except Exception as e:
        return None
