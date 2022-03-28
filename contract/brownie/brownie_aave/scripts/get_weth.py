from scripts.helpful_scripts import get_account
from brownie import interface, config, network, accounts
import sys


def main():
    get_weth()


def get_weth():
    """
    Mints WETH by depositing ETH.
    """
    account = get_account()
    # account = accounts[0]
    weth = interface.IWeth(config["networks"][network.show_active()]["weth_token"])
    tx = weth.deposit({"from": account, "value": 0.001 * 10 ** 18})
    tx.wait(1)
    print("Received 0.001 WETH")
    return tx
