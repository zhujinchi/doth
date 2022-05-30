# -*- coding: utf-8 -*-
'''
@File    :   event_listener.py
@Time    :   2022-05-18 23:37:51
@Author  :   Zejiang Yang
'''

import asyncio
import time
from web3 import Web3
from email_format import format_margincall, format_liquidation
from email_sender import send_mail
from threading import Thread
from configparser import ConfigParser
from flask_start import getEmailByAddress

# Load config
config = ConfigParser()
config.read('doth.config')

DOTH_CONTRACT_ADDRESS = config['Ethereum']['DOTH_CONTRACT_ADDRESS']
INFURA_URL = config['Ethereum']['INFURA_URL']

# Create a HTTPProvider
w3 = Web3(Web3.HTTPProvider(INFURA_URL))


def handle_event(event):
    print(event)
    data = event['data']
    print(data)
    user_address = f'0x{data[26:66]}'
    email_format = int(data[67:], 16)
    print(f'user_address: {user_address}, email_format: {email_format}')
    # TODO get email address from database
    user_email = getEmailByAddress(user_address)
    if email_format == 1:
        send_mail([user_email], "Margin Call", format_margincall)
    elif email_format == 2:
        send_mail([user_email], "Liquidation Call", format_liquidation)


def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        time.sleep(poll_interval)


def event_listener_start():
    """Start event listener used to send warning email to user"""
    event_filter = w3.eth.filter(
        {
            'fromBlock': 1,
            'toBlock': 'latest',
            'address': DOTH_CONTRACT_ADDRESS,
            'topics': [Web3.keccak(text='EmailCall(address,uint256)').hex()],
        }
    )
    worker = Thread(target=log_loop, args=(event_filter, 5), daemon=True)
    worker.start()
    #     # .. do some other stuff


# if __name__ == '__main__':
#     event_listener_start()
#     while True:
#         time.sleep(1)
