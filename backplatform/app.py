import sqlite3

from flask import Flask, render_template, redirect, url_for, request
from sc_connector import *
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from database.my_sqlalchemy import *
import asyncio


app = Flask(__name__)
app.config['SECRET_KEY'] = "secret"
conn = sqlite3.connect('database/test.db', check_same_thread=False)


# Contract parameters setting form
class SettingForm(FlaskForm):
    apr = StringField("APR: ")
    apy = StringField("APY: ")
    initialLTV = StringField("Initial LTV: ")
    liquidationLTV = StringField("Liquidation LTV: ")
    marginCallLTV = StringField("Margin Call LTV: ")
    addToken = StringField("Add Allowed Token: ")
    removeToken = StringField("Remove Allowed Token: ")
    feedAddress = StringField("Set Price Feed Contract: ")
    submit = SubmitField("SUBMIT")


# Entry
@app.route('/')
def access():
    return redirect(url_for('dashboard'))


# Dashboard
@app.route('/dashboard', methods=['GET', 'POST'])
def dashboard():
    global conn
    # Conditional query
    if request.method == "POST":
        id = request.form.get('id')
        firstname = request.form.get('firstname')
        lastname = request.form.get('lastname')
        telephone = request.form.get('telephone')
        email = request.form.get('email')
        data = {
            "id": id,
            "firstname": firstname,
            "lastname": lastname,
            "telephone": telephone,
            "email": email
        }
        sql = "select * from {0} where (id='{1}' and firstname='{2}' and lastname='{3}' and telephone='{4}' " \
              "and email='{5}')".format(User, data['id'], data['firstname'], data['lastname'], data['telephone'],
                                        data['email'])
        users = conn.execute(sql).fetchall()
        return render_template('dashboard.html', title='dashboard', users=users)
    # Default status
    else:
        sql = "select * from User"
        users = conn.execute(sql).fetchall()
        return render_template('dashboard.html', title='dashboard', users=users)


# Transaction hash list
@app.route('/transact/<firstname>/<lastname>/<address>', methods=['GET', 'POST'])
def transact_log(firstname=None, lastname=None, address=None):
    if address is not None:
        log_list = get_user_txn_hash_list(address)
        return render_template('transact.html', title='transact', f_name=firstname, l_name=lastname, log_list=log_list)
    return render_template('transact.html', title='transact', f_name=firstname, l_name=lastname)


# Preserved api_1
@app.route('/profile')
def profile():
    return "profile"


# # Preserved api_2
@app.route('/logout')
def logout():
    return "logout"


# Settings
@app.route('/settings', methods=['GET', 'POST'])
def settings():
    setting_form = SettingForm()
    if request.method == "POST":
        apr = request.form.get('apr')
        apy = request.form.get('apy')
        initialLTV = request.form.get('initialLTV')
        liquidationLTV = request.form.get('liquidationLTV')
        marginCallLTV = request.form.get('marginCallLTV')
        addToken = request.form.get('addToken')
        removeToken = request.form.get('removeToken')
        feedAddress = request.form.get('feedAddress')
        data = {
            "apr": apr,
            "apy": apy,
            "initialLTV": initialLTV,
            "liquidationLTV": liquidationLTV,
            "marginCallLTV": marginCallLTV,
            "addToken": addToken,
            "removeToken": removeToken,
            "feedAddress": feedAddress
        }
        print(data)
        if data['apr'] != '' and data['apr'] is not None :
            setAPR(int(float(apr)*100000000))
            # flash("Set APR Succeed!")
        if data['apy'] != '' and data['apy'] is not None:
            setAPY(int(float(apy)*100000000))
            # flash("Set APY Succeed!")
        if data['initialLTV'] != '' and data['initialLTV'] is not None:
            setInitialLTV(int(float(initialLTV)*10000))
            # flash("Set Initial LTV Succeed!")
        if data['liquidationLTV'] != '' and data['liquidationLTV'] is not None:
            setLiquidationLTV(int(float(liquidationLTV)*10000))
            # flash("Set Liquidation LTV Succeed!")
        if data['marginCallLTV'] != '' and data['marginCallLTV'] is not None:
            setMarginCallLTV(int(float(marginCallLTV)*10000))
            # flash("Set Margin Call LTV Succeed!")
        if data['addToken'] is not None and data['addToken'] != '':
            addAllowedToken(addToken)
            # flash("Add Allowed Token Succeed!")
        if data['removeToken'] is not None and data['removeToken'] != '':
            removeAllowedToken(removeToken)
            # flash("Remove Allowed Token Succeed!")
        if data['feedAddress'] is not None and data['feedAddress'] != '':
            setPriceFeedContract(feedAddress)
            # flash("Set Price Feed Contract Succeed!")
    return render_template('settings.html', apr=getAPR(), apy=getAPY(), initialLTV=getInitialLTV(),
                           liquidationLTV=getLiquidationLTV(), marginCallLTV=getMargincallLTV(), form=setting_form)


if __name__ == "__main__":
    app.run(debug=True, host="localhost", port=60000)
