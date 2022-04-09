from flask import g, jsonify
from flask_httpauth import HTTPBasicAuth
from ..models import User
from . import api
from .errors import unauthorized, forbidden


def uploadFile(request, filename):
    #  获取传入的文件信息
    file_obj = request.FILES.get(filename)

    #  如果传入的文件为空，则返回false
    if file_obj == None:
        return "false"

    #  获取该文件的后缀信息
    houzhui = file_obj.name.split(".")[-1]
    # 写入文件
    file_name = (
        "temp_file-%d" % random.randint(0, 100000) + "." + houzhui
    )  # 不能使用文件名称，因为存在中文，会引起内部错误
    file_full_path = os.path.join("static/upload/", file_name)
    dest = open(file_full_path, "wb+")
    dest.write(file_obj.read())
    dest.close()

    #  返回文件的名字
    return file_name


#  定义跳转到登录页面的方法
def login(request):
    #  返回登录页面
    return render(request, "xitong/login.html")


#  定义跳转到注册页面的方法
def regist(request):
    #  返回注册页面
    return render(request, "xitong/regist.html")


#  定义登录方法
def loginact(request):
    #  从POST中获取username
    username = request.POST["username"]

    #  从POST中获取password
    password = request.POST["password"]

    #  从POST中获取shenfen
    shenfen = request.POST["shenfen"]

    #  如果当前登录身份为管理员
    if shenfen == "管理员":

        #  从admin查询是否有账号面与用户输入一直的管理员信息
        admins = models.Admin.objects.filter(username=username, password=password)

        #  如果查询出的数量大于0
        if admins.count() > 0:
            #  将登录用户的信息保存到session中
            request.session["shenfen"] = shenfen

            #  获取当前登录管理员的id信息
            request.session["id"] = admins[0].id

            #  获取当前登录管理员的mingzi信息
            request.session["mingzi"] = admins[0].username

            #  获取登录管理员的管理员id信息，并赋值给session的id字段
            request.session["id"] = admins[0].id

            #  获取登录管理员的账号信息，并赋值给session的username字段
            request.session["username"] = admins[0].username

            #  获取登录管理员的密码信息，并赋值给session的password字段
            request.session["password"] = admins[0].password

            #  跳转到管理员个人中心
            return render(request, "xitong/adminindex.html")

        #  给出页面提示用户名或密码错误，并跳转到登录页面
        return HttpResponse(u"<p>用户名或密码错误</p><a href='/loginAndRegist/login'>返回页面</a>")

    #  如果当前登录身份为用户
    if shenfen == "用户":

        #  从user查询是否有账号面与用户输入一直的用户信息
        users = models.User.objects.filter(username=username, password=password)

        #  如果查询出的数量大于0
        if users.count() > 0:
            #  将登录用户的信息保存到session中
            request.session["shenfen"] = shenfen

            #  获取当前登录用户的id信息
            request.session["id"] = users[0].id

            #  获取当前登录用户的mingzi信息
            request.session["mingzi"] = users[0].name

            #  获取登录用户的用户id信息，并赋值给session的id字段
            request.session["id"] = users[0].id

            #  获取登录用户的名字信息，并赋值给session的name字段
            request.session["name"] = users[0].name

            #  获取登录用户的真实姓名信息，并赋值给session的realname字段
            request.session["realname"] = users[0].realname

            #  获取登录用户的账号信息，并赋值给session的username字段
            request.session["username"] = users[0].username

            #  获取登录用户的密码信息，并赋值给session的password字段
            request.session["password"] = users[0].password

            #  获取登录用户的性别信息，并赋值给session的sex字段
            request.session["sex"] = users[0].sex

            #  获取登录用户的性别信息，并赋值给session的age字段
            request.session["age"] = users[0].age

            #  获取登录用户的介绍信息，并赋值给session的introduce字段
            request.session["introduce"] = users[0].introduce

            #  跳转到用户个人中心
            return render(request, "xitong/userindex.html")

        #  给出页面提示用户名或密码错误，并跳转到登录页面
        return HttpResponse(u"<p>用户名或密码错误</p><a href='/loginAndRegist/login'>返回页面</a>")

    #  给出页面提示请选择登录身份，并跳转到登录页面
    return HttpResponse(
        u"<p>请选择登录身份</p><a href='/loginAndRegist/login'>返回页面</a>返回页面</a>"
    )


#  定义注册方法
def registact(request):
    #  从POST中获取username参数
    username = request.POST["username"]

    #  从POST中获取password参数
    password = request.POST["password"]

    #  从POST中获取shenfen参数
    shenfen = request.POST["shenfen"]

    #  从POST中获取repassword参数
    repassword = request.POST["repassword"]

    #  如果password与repassword不一致
    if password != repassword:
        #  返回两次密码不一致的提示信息，并返回登录页面
        return HttpResponse(u"<p>两次密码不一致</p><a href='/loginAndRegist/login'>返回页面</a>")

    #  如果当前注册身份为管理员
    if shenfen == "管理员":

        #  根据页面传入的username信息，查询系统中的管理员信息
        admins = models.Admin.objects.filter(username=username)

        #  如果数据数量大于0
        if admins.count() > 0:

            #  给出用户提示该账号已存在，并跳转到注册页面
            return HttpResponse(
                u"<p>该账号已存在</p><a href='/loginAndRegist/regist'>返回页面</a>"
            )
        else:

            #  将传入的管理员信息保存到admin表中
            admin = models.Admin(username=username, password=password)
            admin.save()

            #  给出用户提示注册成功，并跳转到登录页面
            return HttpResponse(
                u"<p>注册成功</p><a href='/loginAndRegist/login/'>点击跳转到登录界面</a>"
            )

    #  如果当前注册身份为用户
    if shenfen == "用户":

        #  根据页面传入的username信息，查询系统中的用户信息
        users = models.User.objects.filter(username=username)

        #  如果数据数量大于0
        if users.count() > 0:

            #  给出用户提示该账号已存在，并跳转到注册页面
            return HttpResponse(
                u"<p>该账号已存在</p><a href='/loginAndRegist/regist'>返回页面</a>"
            )
        else:

            #  将传入的用户信息保存到user表中
            user = models.User(username=username, password=password, name="默认名字")
            user.save()

            #  给出用户提示注册成功，并跳转到登录页面
            return HttpResponse(
                u"<p>注册成功</p><a href='/loginAndRegist/login/'>点击跳转到登录界面</a>"
            )

    #  给出页面提示请选择注册身份，并跳转到注册页面
    return HttpResponse(u"<p>请选择注册身份</p><a href='/loginAndRegist/regist'>返回页面</a>")


#  定义退出系统方法
def tuichuxitong(request):
    #  清除用户session信息
    request.session.clear()

    #  返回系统登录页面
    return render(request, "xitong/login.html")


#  定义跳转管理员个人中心
def adminindex(request):
    #  返回管理员个人中心页面
    return render(request, "xitong/adminindex.html")


#  定义跳转用户个人中心
def userindex(request):
    #  返回用户个人中心页面
    return render(request, "xitong/userindex.html")


#  定义处理管理员修改个人信息的方法
def adminxiugaigerenxinxiact(request):
    #  获取需要修改的管理员id信息
    id = request.POST.get("id")

    #  根据传入的管理员id信息使用get方法获取管理员信息
    admin = models.Admin.objects.get(id=id)

    #  从POST中获取管理员id信息，并赋值给admin的id字段
    admin.id = request.POST.get("id")

    #  从POST中获取管理员id信息，并赋值给session的id字段
    request.session["id"] = request.POST.get("id")

    #  从POST中获取账号信息，并赋值给admin的username字段
    admin.username = request.POST.get("username")

    #  从POST中获取账号信息，并赋值给session的username字段
    request.session["username"] = request.POST.get("username")

    #  从POST中获取密码信息，并赋值给admin的password字段
    admin.password = request.POST.get("password")

    #  从POST中获取密码信息，并赋值给session的password字段
    request.session["password"] = request.POST.get("password")

    #  使用save方法保存管理员信息
    admin.save()

    #  给出页面提示修改成功，并跳转到管理员个人中心
    return HttpResponse(u"<p>修改成功</p><a href='/loginAndRegist/adminindex'>返回页面</a>")


#  定义处理用户修改个人信息的方法
def userxiugaigerenxinxiact(request):
    #  获取需要修改的用户id信息
    id = request.POST.get("id")
    #  根据传入的用户id信息使用get方法获取用户信息
    user = models.User.objects.get(id=id)
    #  从POST中获取用户id信息，并赋值给user的id字段
    user.id = request.POST.get("id")
    #  从POST中获取用户id信息，并赋值给session的id字段
    request.session["id"] = request.POST.get("id")
    #  从POST中获取名字信息，并赋值给user的name字段
    user.name = request.POST.get("name")
    #  从POST中获取名字信息，并赋值给session的name字段
    request.session["name"] = request.POST.get("name")
    #  从POST中获取真实姓名信息，并赋值给user的realname字段
    user.realname = request.POST.get("realname")
    #  从POST中获取真实姓名信息，并赋值给session的realname字段
    request.session["realname"] = request.POST.get("realname")
    #  从POST中获取账号信息，并赋值给user的username字段
    user.username = request.POST.get("username")
    #  从POST中获取账号信息，并赋值给session的username字段
    request.session["username"] = request.POST.get("username")
    #  从POST中获取密码信息，并赋值给user的password字段
    user.password = request.POST.get("password")
    #  从POST中获取密码信息，并赋值给session的password字段
    request.session["password"] = request.POST.get("password")
    #  从POST中获取性别信息，并赋值给user的sex字段
    user.sex = request.POST.get("sex")
    #  从POST中获取性别信息，并赋值给session的sex字段
    request.session["sex"] = request.POST.get("sex")
    #  从POST中获取性别信息，并赋值给user的age字段
    user.age = request.POST.get("age")
    #  从POST中获取性别信息，并赋值给session的age字段
    request.session["age"] = request.POST.get("age")
    #  从POST中获取介绍信息，并赋值给user的introduce字段
    user.introduce = request.POST.get("introduce")
    #  从POST中获取介绍信息，并赋值给session的introduce字段
    request.session["introduce"] = request.POST.get("introduce")
    #  使用save方法保存用户信息
    user.save()
    #  给出页面提示修改成功，并跳转到用户个人中心
    return HttpResponse(u"<p>修改成功</p><a href='/loginAndRegist/userindex'>返回页面</a>")
