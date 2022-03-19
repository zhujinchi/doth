import json

import os

from solcx import compile_standard

from dotenv import load_dotenv
from web3 import Web3

load_dotenv()


with open(
    "/Users/mac/Desktop/doth/contract/ganache_rinkeby_simple_storage/SimpleStorage.sol",
    "r",
) as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)


# # Solidity source code
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

# print(compiled_sol)


with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# # get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]


# # get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# print(abi)

# json.loads(
#     compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["metadata"]
# )["output"]["abi"]


# For connecting to ganache

w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/0ea721bcef8845e794e27459f65d1588")
)

chain_id = 4

my_address = "0x5BaDe43d84a75B877c9C8f35fE3ac70C1ecaAe20"

private_key = "ade6eb310ff5625c314499f75a2dc7c1b3a80a0527a8509fffd39847baca0b0c"

# private_key = os.getenv("PRIVATE_KEY")


# Create the contract
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# print(SimpleStorage)


# # Get the latest transaction
nonce = w3.eth.getTransactionCount(my_address)

# print(nonce)


# Submit the transaction that deploys the contract
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }
)

# print(transaction)


# Sign the transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying Contract")

# Send the transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

# Wait for the transaction to be mined, and get the transaction receipt
# print("Waiting for transaction to finish...")
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
# print(f"Done! Contract deployed to {tx_receipt.contractAddress}")
print("Deployed Contract")


# Working with deployed Contracts
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

print(simple_storage.functions.retrieve().call())

# print(simple_storage.functions.store(15).call())


# Creat the transaction
print("Updating Contract")

store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)


# Sign the transaction
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)


# Send the transaction
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)


# Wait the transaction finish
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print("Updated Contract")

print(simple_storage.functions.retrieve().call())
