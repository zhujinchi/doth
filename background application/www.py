from flask import render_template, url_for, app, request
# from flask_login import LoginManager
from sqlalchemy import text,func
# from my_sql import sessionsql,Users
# from flask_login import login_user,current_user,login_required,logout_user,UserMixin

# 配置 SELECT_KEY
from werkzeug.utils import redirect

app.config['SECRET_KEY'] = 'doth_application'
login_manager = LoginManager()  # 实例化登录管理对象
login_manager.init_app(app)  # 初始化应用
login_manager.login_view = 'login'

class User(UserMixin):
    pass



# 定义获取登录用户的方法
@login_manager.user_loader
def user_loader(user_name):
    try:
        users=sessionsql.query(Users.name).all()
    except:
        sessionsql.rollback()
    finally:
        sessionsql.close()
    if (user_name,) not in users:
        return
    user = User()
    user.id = user_name
    return user




@login_manager.request_loader
def request_loader(request):
    user_name = request.form.get('uname')
    try:
        users = sessionsql.query(Users.name).all()
    except:
        sessionsql.rollback()
    finally:
        sessionsql.close()
    if user_name not in users:
        return
    user = User()
    user.id = user_name
    try:
        admin_pass = sessionsql.query(Users.password).from_statement(
            text("SELECT * FROM admin_info where name=:name")).params(name=user_name).all()
        (pass_word,) = admin_pass
    except:
        sessionsql.rollback()
        admin_pass=""
    finally:
        sessionsql.close()
    user.is_authenticated = pass_word == admin_pass
    return user




@app.route('/login', methods=('GET', 'POST'))  # 登录
def login():
    user_name = request.form.get('uname')
    upwd = request.form.get('upwd')
    if request.method == 'GET':
        return render_template("login.html")
    else:
        try:
            users=sessionsql.query(Users.name).all()
        except:
            sessionsql.rollback()
        finally:
            sessionsql.close()
        if (user_name,) in users:
            try:
                admin_pass = sessionsql.query(Users.password).from_statement(
                    text("SELECT * FROM admin_info where name=:name")).params(name=user_name).all()
            except:
                sessionsql.rollback()
                return render_template('login.html', msg='密码错误，请重试！！！')
            finally:
                sessionsql.close()
            if (upwd,) in admin_pass:
                user = User()
                user.id = user_name
                login_user(user)
                return render_template('home.html',user=current_user.get_id())
            else:
                msg="密码错误"
        else:
            msg="账号不存在"
        return render_template('login.html',msg=msg)




@app.route('/home',methods=('GET', 'POST'))
@login_required
def home():
    return render_template('home.html',user=current_user.get_id())




@app.route('/sign_out',methods=['get'])
def sign_out():
    logout_user()
    return redirect(url_for('login'))




app.run(host="0.0.0.0")
