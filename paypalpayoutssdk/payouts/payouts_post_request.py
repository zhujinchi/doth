# This class was generated on Mon, 23 Dec 2019 12:39:22 IST by version 0.1.0-dev+904328-dirty of Braintree SDK Generator
# payouts_post_request.py
# @version 0.1.0-dev+904328-dirty
# @type request
# @data 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
# DO NOT EDIT
import paypalhttp

try:
    from urllib import quote  # Python 2.X
except ImportError:
    from urllib.parse import quote  # Python 3+

class PayoutsPostRequest:
    """
    Creates a batch payout. In the JSON request body, pass a `sender_batch_header` and an `items` array. The `sender_batch_header` defines how to handle the payout. The `items` array defines the payout items.<br/>You can make payouts to one or more recipients.<blockquote><strong>Notes:</strong> <ul><li><p>PayPal does not process duplicate payouts. If you specify a <code>sender_batch_id</code> that was used in the last 30 days, the API rejects the request with an error message that shows the duplicate <code>sender_batch_id</code> and includes a HATEOAS link to the original payout with the same <code>sender_batch_id</code>.</p><p>If you receive an HTTP <code>5<i>nn</i></code> status code, you can safely retry the request with the same <code>sender_batch_id</code>.</p></li><li><p>The Payouts API does not support build notation (BN) codes. In a future Payouts release, you can optionally provide BN codes in the <code>PayPal-Partner-Attribution-Id</code> request header.</p><p>For information about the <code>PayPal-Partner-Attribution-Id</code> header, see <a href="/docs/api/reference/api-requests/#http-request-headers">HTTP request headers</a>. To learn about or request a BN code, contact your partner manager or see <a href="https://www.paypal.com/us/webapps/mpp/partner-program">PayPal Partner Program</a>.</p></li></ul></blockquote>
    """
    def __init__(self):
        self.verb = "POST"
        self.path = "/v1/payments/payouts?"
        self.headers = {}
        self.headers["Content-Type"] = "application/json"
        self.body = None

    def pay_pal_partner_attribution_id(self, pay_pal_partner_attribution_id):
        self.headers["PayPal-Partner-Attribution-Id"] = str(pay_pal_partner_attribution_id)

    def pay_pal_request_id(self, pay_pal_request_id):
        self.headers["PayPal-Request-Id"] = str(pay_pal_request_id)

    
    
    def request_body(self, create_payout_request):
        self.body = create_payout_request
        return self
