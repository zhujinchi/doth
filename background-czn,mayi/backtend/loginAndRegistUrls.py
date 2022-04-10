# coding:utf-8
from flask import g, jsonify
from flask_httpauth import HTTPBasicAuth
from ..models import User
from . import api
from .errors import unauthorized, forbidden
from . import loginAndRegistViews

urlpatterns = [
    #  定义login的url响应方法，执行loginAndRegistViews的login方法
    url(r"^login/$", loginAndRegistViews.login, name="login"),
    #  定义regist的url响应方法，执行loginAndRegistViews的regist方法
    url(r"^regist/$", loginAndRegistViews.regist, name="regist"),
    #  定义loginact的url响应方法，执行loginAndRegistViews的loginact方法
    url(r"^loginact/", loginAndRegistViews.loginact, name="loginact"),
    #  定义registact的url响应方法，执行loginAndRegistViews的registact方法
    url(r"^registact/$", loginAndRegistViews.registact, name="registact"),
    #  定义tuichuxitong的url响应方法，执行loginAndRegistViews的tuichuxitong方法
    url(r"^tuichuxitong/$", loginAndRegistViews.tuichuxitong, name="tuichuxitong"),
    #  定义 adminindex url响应，响应 loginAndRegistViews的adminindex方法
    url(r"^adminindex/$", loginAndRegistViews.adminindex, name="adminindex"),
    #  定义 adminxiugaigerenxinxiact url响应，响应 loginAndRegistViews的adminxiugaigerenxinxiact方法
    url(
        r"^adminxiugaigerenxinxiact/$",
        loginAndRegistViews.adminxiugaigerenxinxiact,
        name="adminxiugaigerenxinxiact",
    ),
    #  定义 userindex url响应，响应 loginAndRegistViews的userindex方法
    url(r"^userindex/$", loginAndRegistViews.userindex, name="userindex"),
    #  定义 userxiugaigerenxinxiact url响应，响应 loginAndRegistViews的userxiugaigerenxinxiact方法
    url(
        r"^userxiugaigerenxinxiact/$",
        loginAndRegistViews.userxiugaigerenxinxiact,
        name="userxiugaigerenxinxiact",
    ),
]
