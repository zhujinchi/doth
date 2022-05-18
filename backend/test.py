# 88R38746XY683332A
from paypalpayoutssdk.payouts import PayoutsPostRequest
from paypalhttp import HttpError, Json
from paypalhttp.encoder import Encoder
from paypalpayoutssdk.core import PayPalHttpClient, SandboxEnvironment
from paypalcheckoutsdk.orders import OrdersCreateRequest
from paypalcheckoutsdk.orders import OrdersCaptureRequest
# Here, OrdersCaptureRequest() creates a POST request to /v2/checkout/orders
# Replace APPROVED-ORDER-ID with the actual approved order id.
request = OrdersCaptureRequest("8KM17517CY768204D")
# paypal环境
business_address = "doth_test_business@test.com"
MY_DOMAIN = 'http://1.14.103.90:5000'
client_id = (
    "AU053UWAC0R5AmO_gq6DELT9n7ikP8ljzAUMzQBLOHTl4GuVVnatUXn9_CpT2xIM5qayeqK0YsY-rosW"
)
client_secret = (
    "EA2qKfrCkZkDtPH4x1NUA3nJkuJGiqxJcxkOwu13ve4-s1jf-3w67NM8WYMxvty-XpZy5d0CqX-JFwBf"
)
environment = SandboxEnvironment(client_id=client_id, client_secret=client_secret)
client = PayPalHttpClient(environment)
try:
    # Call API with your client and get a response for your call
    response = client.execute(request)

    # If call returns body in response, you can get the deserialized version from the result attribute of the response
    order = response.result.id
    print(order)
except IOError as ioe:
    print(ioe)