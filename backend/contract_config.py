import json
from typing import Union
from eth_typing import HexStr
import json
from web3 import Web3

infura_url = "https://kovan.infura.io/v3/94bbef5545ef45c8a2f42d89365df347"

w3 = Web3(Web3.HTTPProvider(infura_url))

if w3.isConnected():
    print("Connection with smart contract succeed! ")
else:
    print("Connection with smart contract failed! ")

abi = json.loads('[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{'
                 '"indexed":true,"internalType":"address","name":"manager","type":"address"},{"indexed":false,'
                 '"internalType":"address","name":"token","type":"address"}],"name":"AddAllowedToken",'
                 '"type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address",'
                 '"name":"manager","type":"address"}],"name":"AddManager","type":"event"},{"anonymous":false,'
                 '"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},'
                 '{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Borrow",'
                 '"type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address",'
                 '"name":"user","type":"address"},{"indexed":true,"internalType":"address","name":"token",'
                 '"type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],'
                 '"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,'
                 '"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256",'
                 '"name":"format","type":"uint256"}],"name":"EmailCall","type":"event"},{"anonymous":false,'
                 '"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,'
                 '"internalType":"address","name":"token","type":"address"},{"indexed":false,'
                 '"internalType":"uint256","name":"amount","type":"uint256"}],"name":"IWithdraw","type":"event"},'
                 '{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"user",'
                 '"type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],'
                 '"name":"Liquidate","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,'
                 '"internalType":"address","name":"manager","type":"address"},{"indexed":false,'
                 '"internalType":"address","name":"token","type":"address"}],"name":"RemoveAllowedToken",'
                 '"type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address",'
                 '"name":"manager","type":"address"}],"name":"RemoveManager","type":"event"},{"anonymous":false,'
                 '"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},'
                 '{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],'
                 '"name":"RepayByCollateral","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,'
                 '"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256",'
                 '"name":"amount","type":"uint256"}],"name":"RepayByUSD","type":"event"},{"anonymous":false,'
                 '"inputs":[{"indexed":false,"internalType":"uint256","name":"APR","type":"uint256"}],'
                 '"name":"SetAPR","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,'
                 '"internalType":"uint256","name":"APY","type":"uint256"}],"name":"SetAPY","type":"event"},'
                 '{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"LTV",'
                 '"type":"uint256"}],"name":"SetIntialLTV","type":"event"},{"anonymous":false,"inputs":[{'
                 '"indexed":false,"internalType":"uint256","name":"LTV","type":"uint256"}],'
                 '"name":"SetLiquidationLTV","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,'
                 '"internalType":"uint256","name":"LTV","type":"uint256"}],"name":"SetMarginCallLTV","type":"event"},'
                 '{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"token",'
                 '"type":"address"},{"indexed":false,"internalType":"address","name":"priceFeed","type":"address"}],'
                 '"name":"SetPriceFeedContract","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,'
                 '"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"address",'
                 '"name":"token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount",'
                 '"type":"uint256"}],"name":"Withdraw","type":"event"},{"inputs":[],"name":"APR","outputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[],"name":"APY","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                 '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_token",'
                 '"type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],'
                 '"name":"USDInToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                 '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_token",'
                 '"type":"address"}],"name":"addAllowedToken","outputs":[],"stateMutability":"nonpayable",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"_manager","type":"address"}],'
                 '"name":"addManager","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"name":"allowedTokens","outputs":[{'
                 '"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"borrow",'
                 '"outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"name":"borrowers","outputs":[{'
                 '"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"bytes","name":"","type":"bytes"}],"name":"checkUpkeep","outputs":[{'
                 '"internalType":"bool","name":"upkeepNeeded","type":"bool"},{"internalType":"bytes","name":"",'
                 '"type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address",'
                 '"name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],'
                 '"name":"deposit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"name":"depositors","outputs":[{'
                 '"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[],"name":"getBorrowers","outputs":[{"internalType":"address[]","name":"",'
                 '"type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                 '"internalType":"uint256","name":"_timestamp","type":"uint256"}],"name":"getDaysFromNow","outputs":['
                 '{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[],"name":"getDepositors","outputs":[{"internalType":"address[]","name":"",'
                 '"type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                 '"internalType":"address","name":"_user","type":"address"}],"name":"getLTV","outputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"getTokenValue",'
                 '"outputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256",'
                 '"name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],'
                 '"name":"getTotalTokens","outputs":[{"internalType":"address[]","name":"","type":"address[]"},'
                 '{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"_user","type":"address"}],'
                 '"name":"getUserLoanValue","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                 '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_user",'
                 '"type":"address"},{"internalType":"address","name":"_token","type":"address"}],'
                 '"name":"getUserSingleTokenAmount","outputs":[{"internalType":"uint256","name":"",'
                 '"type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                 '"internalType":"address","name":"_user","type":"address"},{"internalType":"address",'
                 '"name":"_token","type":"address"}],"name":"getUserSingleTokenValue","outputs":[{'
                 '"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"address","name":"_user","type":"address"}],"name":"getUserTotalValue",'
                 '"outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},'
                 '{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256",'
                 '"name":"_amount","type":"uint256"}],"name":"iWithdraw","outputs":[],"stateMutability":"nonpayable",'
                 '"type":"function"},{"inputs":[],"name":"initialLTV","outputs":[{"internalType":"uint256","name":"",'
                 '"type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                 '"internalType":"address","name":"_user","type":"address"}],"name":"isBorrower","outputs":[{'
                 '"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"address","name":"_user","type":"address"}],"name":"isDepositor",'
                 '"outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"_manager","type":"address"}],'
                 '"name":"isManager","outputs":[{"internalType":"bool","name":"","type":"bool"}],'
                 '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_token",'
                 '"type":"address"}],"name":"isTokenExisted","outputs":[{"internalType":"bool","name":"",'
                 '"type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"liquidationLTV",'
                 '"outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],'
                 '"name":"loanBalance","outputs":[{"internalType":"uint256","name":"principal","type":"uint256"},'
                 '{"internalType":"uint256","name":"interest","type":"uint256"},{"internalType":"uint256",'
                 '"name":"timestamp","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],'
                 '"name":"marginCallLTV","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                 '"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{'
                 '"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},'
                 '{"inputs":[{"internalType":"bytes","name":"","type":"bytes"}],"name":"performUpkeep","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address",'
                 '"name":"_token","type":"address"}],"name":"removeAllowedToken","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address",'
                 '"name":"_manager","type":"address"}],"name":"removeManager","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]",'
                 '"name":"_tokens","type":"address[]"},{"internalType":"uint256","name":"_amount","type":"uint256"}],'
                 '"name":"repayByCollateral","outputs":[],"stateMutability":"nonpayable","type":"function"},'
                 '{"inputs":[{"internalType":"address","name":"_user","type":"address"},{"internalType":"uint256",'
                 '"name":"_amount","type":"uint256"}],"name":"repayByUSD","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256",'
                 '"name":"_APR","type":"uint256"}],"name":"setAPR","outputs":[],"stateMutability":"nonpayable",'
                 '"type":"function"},{"inputs":[{"internalType":"uint256","name":"_APY","type":"uint256"}],'
                 '"name":"setAPY","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                 '"internalType":"uint256","name":"_LTV","type":"uint256"}],"name":"setIntialLTV","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256",'
                 '"name":"_LTV","type":"uint256"}],"name":"setLiquidationLTV","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256",'
                 '"name":"_LTV","type":"uint256"}],"name":"setMarginCallLTV","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address",'
                 '"name":"_token","type":"address"},{"internalType":"address","name":"_priceFeed","type":"address"}],'
                 '"name":"setPriceFeedContract","outputs":[],"stateMutability":"nonpayable","type":"function"},'
                 '{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"tokenPriceFeedMapping",'
                 '"outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view",'
                 '"type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},'
                 '{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"withdraw","outputs":[],'
                 '"stateMutability":"nonpayable","type":"function"}]')

contract_address = w3.toChecksumAddress("0x80596450a684A8c43e57c1B246C690Cb85EA2138")

contract = w3.eth.contract(address=contract_address, abi=abi)

print(contract.functions.getTotalTokens().call())

manager_account = w3.toChecksumAddress("0xFD728264272DB9bB87D763c68E3c68346800a157")

private_key = "ee5aea8ca45c063ad045ba0c77a46a71541e1a6e3bc9bb3ba7b3433e358e194d"

nonce = w3.eth.getTransactionCount(manager_account)

addAllowedToken_transaction = contract.functions.addAllowedToken(manager_account).buildTransaction(
    {
        "chainId": 42,  # Kovan: 42
        "gasPrice": w3.eth.gas_price,
        "from": manager_account,
        "nonce": nonce,
    }
)
signed_addAllowedToken_txn = w3.eth.account.sign_transaction(
    addAllowedToken_transaction, private_key=private_key
)
tx_addAllowedToken_hash = w3.eth.send_raw_transaction(signed_addAllowedToken_txn.rawTransaction)
print("Updating stored Value...")

# tx_receipt = w3.eth.wait_for_transaction_receipt(tx_addAllowedToken_hash, timeout=120)
# print(tx_receipt)

print(contract.functions.getTotalTokens().call())





# print(contract)
# totalSupply = contract.functions.totalSupply().call()
# print(totalSupply)
# print(contract.functions.name().call())

# balance = w3.eth.getBalance(contract_address)
#
# balance = w3.fromWei(balance, "ether")
#
# print(balance)

