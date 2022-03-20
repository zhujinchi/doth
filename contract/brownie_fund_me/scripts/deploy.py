from brownie import FundMe, network, config, MockV3Aggregator
from scripts.helpful_scripts import (
    get_account,
    deploy_mocks,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
)

from web3 import Web3


def deploy_fund_me():
    account = get_account()

    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        # price_feed_address = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e"
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]

    else:
        deploy_mocks()
        # print(f"active network is {network.show_active()}")
        # print("Deploying Mocks")

        # if len(MockV3Aggregator) <= 0:
        #     MockV3Aggregator.deploy(18, Web3.toWei(2000, "ether"), {"from": account})

        # # price_feed_address = mock_aggregater.address
        # print("Deployed Mocks")
        price_feed_address = MockV3Aggregator[-1].address

        # deploy_mocks()

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        # publish_source=True,
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"deployed to {fund_me.address}")
    return fund_me

    # if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
    #     price_feed_address = config["networks"][network.show_active()][
    #         "eth_usd_price_feed"
    #     ]
    # else:
    #     deploy_mocks()
    #     price_feed_address = MockV3Aggregator[-1].address

    # print(f"Contract deployed to {fund_me.address}")
    # return fund_me


def main():
    deploy_fund_me()
