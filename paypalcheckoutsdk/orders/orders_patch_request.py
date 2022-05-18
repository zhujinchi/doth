# This class was generated on Mon, 02 Jul 2018 17:09:03 PDT by version 0.1.0-dev+0ee05a-dirty of Braintree SDK Generator
# orders_patch_request.py
# @version 0.1.0-dev+0ee05a-dirty
# @type request
# @data H4sIAAAAAAAC/+RXTW8jNwy991cIOg/sYFv0MDcjSZF+7MZN3AWKbWAzEp3R7sxQpaikRuD/Xmg0/ho33W67TVHkZOuJ1LwnUiL1qN9Ag7rUxBY5jDyIqXShzzAYdl4ctbrUP3kLgkFBqzq7kfqZojLQqtjNbCfUg5NKLU6vziez87OFIlaLyXR6dfk2jYKAxLB1bkme8r98Pf3hfLbvM6tQLamu6cG1dwpE2N3GzMkqun2PRoICRtUpgNsay1/iycmXJtbdL+ZR7fZHhmz+h64VbCWj4x08UtfRe2JBq8gjQ9oQ5YIa+jP6GgweL9Ajh999ioWPbCoIOI+tk/DX2GTVw5XA2iP3bqueg/i7m5GJQaiZO/ufinjCuKH7zy7Y7g7MS5HsYYU4wgZc/X9O1VA57117NwdrGUN4KeELtJT5Jm2JX4psaCg+300/3pQfXegfI/JqCgwNCnLQ5bubQl8gWOQh+g1xM8SmINUB9qhnK59qdxB27Z0u9Ftgl0rffk2fO6sL/T2uevCouKfK+u2ZoqWSCvsyLNRX5pEu9IQZVvlTJ4W+QrCXbb3S5RLqgAn4NTpGq0vhiIWecto/cRh02ca6Xt9kGwySF9nynvbNxoB2V8HnnF0OuA9nDoVMWgWJapLy3fXlm9wKbJsDIQXe1yvlgcVB3SvsJhgDRTYYBnq//lO9PbAv+ONBWTI1B6J64DgoWQOl1qSLSAqPAN+hKEsmNtiKqsnkTE2rqIfKmSqZpoPT2d9DHXGkNpzVkrjDF8liscv0T4rzH+juAl18PCP9gfRueCx8d/6ElKHG1/iJmfj3GXqQaphz1T8PD8guOBtF+bz9SxHIWX+sr0uIA4Eb5FhhN7M9N7kHX+RbeS91lCUMKjXznPkp6NPucyi6WSer4KkNmNdJcKFPqevYe7WJoMtbPX4fqNWFvhDxr1EqsummmcxOL3S+Q3Wpx/evxqZC84GijPPLZ/y4uS3XutDXH5zfcjr/zaMRtNfdU+SULOry1clX6y9+BwAA//8=
# DO NOT EDIT
import paypalhttp

try:
    from urllib import quote  # Python 2.X
except ImportError:
    from urllib.parse import quote  # Python 3+

class OrdersPatchRequest:
    """
    Updates an order. You can update an order with `CREATED` or `APPROVED` status. You cannot update an order with `COMPLETED` status. The following attributes and objects are patchable:<ul><li><code>intent</code>. Supported operation is <code>replace</code>.</li><li><code>purchase_units</code>. Supported operations are <code>add</code> and <code>replace</code>.</li><li><code>purchase_units[].custom_id</code>. Supported operations are <code>add</code> and <code>replace</code> and <code>remove</code>.</li><li><code>purchase_units[].description</code>. Supported operations are <code>add</code> and <code>replace</code> and <code>remove</code>.</li><li><code>purchase_units[].payee.email</code>. Supported operations are <code>add</code> and <code>replace</code>.</li><li><code>purchase_units[].shipping_address</code>. Supported operations are <code>add</code> and <code>replace</code> and <code>remove</code>.</li><li><code>purchase_units[].soft_descriptor</code>. Supported operations are <code>add</code> and <code>replace</code> and <code>remove</code>.</li><li><code>purchase_units[].amount</code>. Supported operation is <code>replace</code>.</li></ul>
    """
    def __init__(self, order_id):
        self.verb = "PATCH"
        self.path = "/v2/checkout/orders/{order_id}?".replace("{order_id}", quote(str(order_id)))
        self.headers = {}
        self.headers["Content-Type"] = "application/json"
        self.body = None



    def request_body(self, patch_request):
        self.body = patch_request
        return self
