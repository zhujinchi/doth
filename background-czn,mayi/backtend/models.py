from __future__ import unicode_literals
from django.db import models


# Create your models here.
class Admin(models.Model):
    id = models.AutoField(primary_key=True);
    username = models.CharField(max_length=500, null=True, default="");
    password = models.CharField(max_length=500, null=True, default="");


class User(models.Model):
    id = models.AutoField(primary_key=True);
    name = models.CharField(max_length=500, null=True, default="");
    realname = models.CharField(max_length=500, null=True, default="");
    username = models.CharField(max_length=500, null=True, default="");
    password = models.CharField(max_length=500, null=True, default="");
    sex = models.CharField(max_length=500, null=True, default="");
    age = models.CharField(max_length=500, null=True, default="");
    introduce = models.CharField(max_length=500, null=True, default="");


class Team(models.Model):
    id = models.AutoField(primary_key=True);
    name = models.CharField(max_length=500, null=True, default="");
    user = models.CharField(max_length=500, null=True, default="");
    userid = models.CharField(max_length=500, null=True, default="");
    introduce = models.CharField(max_length=500, null=True, default="");


class Teammembers(models.Model):
    id = models.AutoField(primary_key=True);
    team = models.CharField(max_length=500, null=True, default="");
    teamid = models.CharField(max_length=500, null=True, default="");
    user = models.CharField(max_length=500, null=True, default="");
    userid = models.CharField(max_length=500, null=True, default="");


class Chat(models.Model):
    id = models.AutoField(primary_key=True);
    user = models.CharField(max_length=500, null=True, default="");
    userid = models.CharField(max_length=500, null=True, default="");
    addtime = models.CharField(max_length=500, null=True, default="");
    content = models.CharField(max_length=500, null=True, default="");
    team = models.CharField(max_length=500, null=True, default="");
    teamid = models.CharField(max_length=500, null=True, default="");


class Teamnotice(models.Model):
    id = models.AutoField(primary_key=True);
    title = models.CharField(max_length=500, null=True, default="");
    addtime = models.CharField(max_length=500, null=True, default="");
    content = models.CharField(max_length=500, null=True, default="");
    team = models.CharField(max_length=500, null=True, default="");
    teamid = models.CharField(max_length=500, null=True, default="");


class Invitation(models.Model):
    id = models.AutoField(primary_key=True);
    team = models.CharField(max_length=500, null=True, default="");
    teamid = models.CharField(max_length=500, null=True, default="");
    user = models.CharField(max_length=500, null=True, default="");
    userid = models.CharField(max_length=500, null=True, default="");
    state = models.CharField(max_length=500, null=True, default="");


class Paper(models.Model):
    id = models.AutoField(primary_key=True);
    title = models.CharField(max_length=500, null=True, default="");
    addtime = models.CharField(max_length=500, null=True, default="");
    content = models.CharField(max_length=500, null=True, default="");
    biaoqian1 = models.CharField(max_length=500, null=True, default="");
    biaoqian2 = models.CharField(max_length=500, null=True, default="");
    biaoqian3 = models.CharField(max_length=500, null=True, default="");
    biaoqian4 = models.CharField(max_length=500, null=True, default="");
    tfidfci1 = models.CharField(max_length=500, null=True, default="");
    tfidfci2 = models.CharField(max_length=500, null=True, default="");
    tfidfci3 = models.CharField(max_length=500, null=True, default="");
    tfidfci4 = models.CharField(max_length=500, null=True, default="");
    kmeansci1 = models.CharField(max_length=500, null=True, default="");
    kmeansci2 = models.CharField(max_length=500, null=True, default="");
    kmeansci3 = models.CharField(max_length=500, null=True, default="");
    kmeansci4 = models.CharField(max_length=500, null=True, default="");
    jurisdiction = models.CharField(max_length=500, null=True, default="");
    user = models.CharField(max_length=500, null=True, default="");
    userid = models.CharField(max_length=500, null=True, default="");
    state = models.CharField(max_length=500, null=True, default="");
    file = models.CharField(max_length=500, null=True, default="");
