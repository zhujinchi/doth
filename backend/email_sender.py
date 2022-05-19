# -*- coding: utf-8 -*-
'''
@File    :   email_sender.py
@Time    :   2022-05-13 21:02:47
@Author  :   Zejiang Yang
'''

import socks
import smtplib
from email.utils import COMMASPACE
from email.header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email_format import format_margincall, format_liquidation
from configparser import ConfigParser

# Load config
config = ConfigParser()
config.read('doth.config')

SMTP_SERVER = config['SMTP']['SMTP_SERVER']
SMTP_PORT = config['SMTP']['SMTP_PORT']
# Test email account
ACCOUNT_INFO = {'username': 'doth.notice@gmail.com', 'password': 'doth123456'}
SENDER = 'Doth <doth.notice@gmail.com>'


def smtp_connect():
    """Connect to the SMTP server.
    :param smtp_server:smtp sever address
    :param smtp_port:smtp TLS/STARTTLS port
    """
    # add socks5 proxy
    # socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, 'x.x.x.x', 29900, True)
    # socks.wrapmodule(smtplib)
    smtp = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    smtp.ehlo()
    smtp.starttls()
    smtp.login(ACCOUNT_INFO['username'], ACCOUNT_INFO['password'])
    print('---smpt connect success!---')
    return smtp


def send_mail(
    receivers,
    subject,
    text,
    sender=SENDER,
):
    """
    :param receivers
    :param subject
    :param text
    :param filename
    :return:
    """
    # content
    msg_root = MIMEMultipart()
    msg_root['SUBJECT'] = subject
    msg_root['From'] = sender
    msg_root['To'] = COMMASPACE.join(receivers)
    msg_text = MIMEText(text, 'html', 'utf-8')
    msg_root.attach(msg_text)

    # Attachment
    # att = MIMEApplication(open(filename,'rb').read())
    # att.add_header('Content-Disposition', 'attachment', filename=filename)
    # msg_root.attach(att)

    try:
        smtp = smtp_connect()
        print('---email sending---')
        smtp.sendmail(sender, receivers, msg_root.as_string())
        print('---email send success!---')
        smtp.quit()
        print('---smtp closed---')
        print('')
    except Exception as e:
        print('fail to send')
        print('')


# if __name__ == "__main__":
#     # test
#     send_mail(['464735955@qq.com'], "Margin Call", format_margincall)
#     send_mail(['464735955@qq.com'], "Liquidation Call", format_liquidation)
