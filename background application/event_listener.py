import asyncio
from web3 import Web3
from email_format import format_margincall, format_liquidation
from email_sender import send_mail

DOTH_CONTRACT_ADDRESS = '0x80596450a684A8c43e57c1B246C690Cb85EA2138'
INFURA_URL = "https://kovan.infura.io/v3/e3b3cf0628f04f2c9e54ccd14355ff57"

w3 = Web3(Web3.HTTPProvider(INFURA_URL))


def handle_event(event):
    print(event)
    data = event['data']
    print(data)
    user_address = data[:66]
    email_format = int(data[67:], 16)
    print(f'user_address: {user_address}, email_format: {email_format}')
    if email_format == 1:
        send_mail(['464735955@qq.com'], "Margin Call", format_margincall)
    elif email_format == 2:
        send_mail(['464735955@qq.com'], "Liquidation Call", format_liquidation)


async def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        await asyncio.sleep(poll_interval)


def main():
    block_filter = w3.eth.filter(
        {
            'fromBlock': 1,
            'toBlock': 'latest',
            'address': DOTH_CONTRACT_ADDRESS,
            'topics': [Web3.keccak(text='EmailCall(address,uint256)').hex()],
            # 'topics': [Web3.keccak(text='SetPriceFeedContract(address,address)').hex()],
        }
    )
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(asyncio.gather(log_loop(block_filter, 2)))
    finally:
        loop.close()


if __name__ == '__main__':
    main()
