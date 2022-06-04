import functools

from flask import request
from flask_httpauth import HTTPTokenAuth, make_response
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired
import VO.my_response as R

auth = HTTPTokenAuth(scheme='JWT')

SECRET_KEY = "2bf9fdb6-d94c-4942-b383-2e116f6de7c7"


@auth.verify_token
def verify_token(token):
    s = Serializer(SECRET_KEY)
    try:
        data = s.loads(token)
    except BadSignature:
        print("token not match")
        return False
    except SignatureExpired:
        print("token expired")
        return False
    return True


@auth.error_handler
def errortoken_auth():
    # code 100
    return make_response(R.error(code=100, msg="token not match or expired"), 401)


@auth.get_user_roles
def get_user_roles(header):
    token = header['token']
    s = Serializer(SECRET_KEY)
    try:
        user = s.loads(token)
        return user["role"]
    except Exception as e:
        return None


def create_token(user_id, role="user"):
    s = Serializer(SECRET_KEY, expires_in=3600)
    token = s.dumps({"id": user_id, "role": role}).decode('ascii')
    return token


def get_user():
    token = auth.get_auth()['token']
    s = Serializer(SECRET_KEY)
    try:
        user = s.loads(token)
        return user
    except Exception as e:
        return None
