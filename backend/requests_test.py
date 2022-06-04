import requests
user_address = "0x5bade43d84a75b877c9c8f35fe3ac70c1ecaae20"
user_email = requests.get("http://localhost:5000/get_email",params={"user_address":user_address}).text
print(user_email)