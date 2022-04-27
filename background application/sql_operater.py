from database_model_old import db, User, Money, Manager, Wallet

# 增

# s = user(name="张三", gender="男", phone="12345678900")

# s1 = user(name="kk", gender="女")
# s2 = user(name="张蛋", gender="女")
# s3 = user(name="李四", gender="男")
# s4 = user(name="李鬼", gender="男", phone="12345678900")

# 语句 第一种
# db.session.add(s1)
# db.session.commit()
#
# db.session.add_all([s1, s2, s3, s4])
# db.session.commit()

# 查

# get(id) 查 单一个
# user_get = user.query.get(1)
# print(user_get.name)
# print(user_get.gender)
# print(user_get.phone)

# all() 查全部
# user_get = user.query.all()
# for i in user_get:
#     print(i.name, i.gender, i.phone)

# filter() 条件查询
# user_get = user.query.filter(user.gender == "女")
# for i in user_get:
#     print(i.name, i.id,i.gender)


# filter_by() 比较类似SQL的查询  first() 查询到的第一个
# user_get = user.query.filter_by(name="张三").filter(user.id >= 2)
# for i in user_get:
#     print(i.name, i.id)

# 改
# 第一种
# user_get = user.query.filter(user.id == 1).update({"name": "张毅"})# 返回动了多少条数据
# db.session.commit()

# user_get = user.query.filter(user.gender == "男").update({"gender": "女"})  # 返回动了多少条数据
# print(user_get)
# db.session.commit()

# 第二种
# user_get = user.query.filter(user.gender == "女").all()
# for i in user_get:
#     i.gender = "男"
#     db.session.add(i)
# db.session.commit()


# 删
#
# user_get = user.query.filter(user.id >= 5).delete()  # 返回动了多少条数据
# print(user_get)
# db.session.commit()

# user_get = user.query.all()
# for i in user_get:
#     print(i.gender,i.name)

print("--------------------------")

# money1 = money(money=100, user_id=1)
# money2 = money(money=95, user_id=1)
#
# db.session.add(money1)
# db.session.add(money2)
# db.session.commit()

# user_get = user.query.all()
# for i in user_get:
#     print(i.gender, i.name)

# money = money.query.filter(money.user_id==1).all()
# for i in money:
#     print(i.user)

# 通过 一 访问 多
# user_get = user.query.get(1)
# for i in user_get.moneys:
#     print(user_get.name,i.money)


# 通过 多 访问 一

# money = money.query.filter(money.money == "100").all()
# for i in money:
#     print(i.user.name,i.user.gender)


# 多对多
# user0 = user(name="李玲", gender="女", phone="12345678900")
# user1 = user(name="李依", gender="女", phone="12345678901")
# user2 = user(name="李贰", gender="男", phone="12345678902")
# user3 = user(name="李叁", gender="男", phone="12345678903")
# user4 = user(name="李斯", gender="男", phone="12345678904")
# user5 = user(name="李舞", gender="女", phone="12345678905")
# user6 = user(name="李榴", gender="男", phone="12345678906")
# user7 = user(name="李淇", gender="女", phone="12345678907")
# user8 = user(name="李巴", gender="男", phone="12345678908")
# user9 = user(name="李玖", gender="男", phone="12345678909")
#
# manager0 = manager(name="00", gender="男", phone="12345678910")
# manager1 = manager(name="11", gender="女", phone="12345678911")
# manager2 = manager(name="22", gender="女", phone="12345678912")
# manager3 = manager(name="33", gender="男", phone="12345678913")
# manager4 = manager(name="44", gender="男", phone="12345678914")
# manager5 = manager(name="55", gender="男", phone="12345678915")
#
# wallet0 = wallet(name="00")
# wallet1 = wallet(name="11")
# wallet2 = wallet(name="22")
# wallet3 = wallet(name="33")
# wallet4 = wallet(name="44")
# wallet5 = wallet(name="55")
#
# db.session.add_all(
#     [user0, user1, user2, user3, user4, user5, user6, user7, user8, user9, manager0,
#      manager1, manager2, manager3, manager4, manager5, wallet0, wallet1, wallet2, wallet3, wallet4, wallet5])
# db.session.commit()

# for i in range(1, 7):
#     c = wallet.query.filter(wallet.id == i).update({"manager_id": i})
# db.session.commit()

# 查询钱包
cs = wallet.query.filter(wallet.id >= 2).all()
print(cs)
# 查询用户
user_get = user.query.filter(user.id >= 2).all()
for s in user_get:
    s.wallets = cs
    db.session.add(s)
    db.session.commit()

# 用户查询钱包
user_get = user.query.get(1)
for s in user_get.wallets:
    print(s.name)
print(user_get.wallets)

print("===================")

# 钱包查询用户
c = wallet.query.get(2)
for s in c.users:
    print(s.name)