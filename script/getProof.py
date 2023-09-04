import requests
import json
import logging
import http.client as http_client

# Node URL
url = "https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY"
http_client.HTTPConnection.debuglevel = 1

# You must initialize logging, otherwise you'll not see debug output.
logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True

payload = json.dumps({
  "method": "eth_getProof",
  "params": [
    "CONTRACT_ADDRESS",
    [
      "STORAGE_SLOT_HASH"
    ],
    "latest"
  ],
  "id": 1,
  "jsonrpc": "2.0"
})
headers = {
  'Content-Type': 'application/json'
}

# The raw response proof is not RLP encoded !
response = requests.request("POST", url, headers=headers, data=payload)
print(response.json())