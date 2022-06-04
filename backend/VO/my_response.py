from datetime import datetime as cdatetime
from datetime import date, time
from flask_sqlalchemy import Model
from sqlalchemy import DateTime, Numeric, Date, Time

R = {"code": None, "msg": None, "data": None}


def ok(code=0, msg="ok", data=None):
    R['code'] = code
    R['msg'] = msg
    R['data'] = data
    return R


def error(code=-1, msg="error", data=None):
    R['code'] = code
    R['msg'] = msg
    R['data'] = data
    return R


def queryToDict(models):
    if isinstance(models, list):
        if models == []:
            return []
        if isinstance(models[0], Model):
            lst = []
            for model in models:
                gen = model_to_dict(model)
                dit = dict((g[0], g[1]) for g in gen)
                lst.append(dit)
            return lst
        else:
            res = result_to_dict(models)
            return res
    else:
        if isinstance(models, Model):
            gen = model_to_dict(models)
            dit = dict((g[0], g[1]) for g in gen)
            return dit
        else:
            res = dict(zip(models.keys(), models))
            find_datetime(res)
            return res


def result_to_dict(results):
    res = [dict(zip(r.keys(), r)) for r in results]
    for r in res:
        find_datetime(r)
    return res


def model_to_dict(model):
    for col in model.__table__.columns:
        if isinstance(col.type, DateTime):
            value = convert_datetime(getattr(model, col.name))
        elif isinstance(col.type, Numeric):
            value = float(getattr(model, col.name))
        else:
            value = getattr(model, col.name)
        yield col.name, value


def find_datetime(value):
    for v in value:
        if isinstance(value[v], cdatetime):
            value[v] = convert_datetime(value[v])

def convert_datetime(value):
    if value:
        if isinstance(value, (cdatetime, DateTime)):
            return value.strftime("%Y-%m-%d %H:%M:%S")
        elif isinstance(value, (date, Date)):
            return value.strftime("%Y-%m-%d")
        elif isinstance(value, (Time, time)):
            return value.strftime("%H:%M:%S")
    else:
        return ""
