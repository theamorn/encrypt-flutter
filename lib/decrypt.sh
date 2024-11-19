#!/bin/bash

# echo -n "GoogleDevFestBangkok202401234567" | xxd -p
# echo -n "Xlmqecc/DRddhFj0DatDcA==" | xxd -p
# echo "YAre4DjIuT67lv+fHLQai/J61calIaoPY2recFkkcQ1TJs8wS5JFMU8t7Xo3Dchl2yRzTFyZpOOXFYBeTPouI28Sz7xV5HTa/pbToupShvJmPIrFeIxXU/Joe5cC1gAc5E88cmrlyTWMofTXLvWYZA==" | openssl enc -aes-256-cbc -d -a -K 476f6f676c654465764665737442616e676b6f6b323032343031323334353637 -iv 5e59aa79c73f0d175d8458f40dab4370

ENCRYPTED_STRING=$1
KEY=$2
IV=$3

# Convert KEY to hexadecimal
HEX_KEY=$(echo -n "$KEY" | xxd -p -c 256 | tr -d '\n')
echo "HEX_KEY: $HEX_KEY"

# Convert IV from Base64 to hexadecimal
HEX_IV=$(echo -n "$IV" | base64 -d | xxd -p)
echo "HEX_IV: $HEX_IV"

# Decrypt the string
echo -e ""
echo "Decrypting the string..."
echo -e "$ENCRYPTED_STRING" | openssl enc -aes-256-cbc -d -a -K "$HEX_KEY" -iv "$HEX_IV"
echo -e ""
echo -e ""
echo "Checking Signature..."
echo -n "$ENCRYPTED_STRING" | shasum -a 256 | cut -d ' ' -f1

bash decrypt.sh AxPXu5CJOc+XHgj4Xi5C39lieXaIBiIOKNDXwlZtDiA4do3QX8F6DcuCxYk//hpgM24Igj8Twt7F33FJ6EnDE7fGFVnf1PPcriV6E4s+Lu+aN16Fldie48O5TnoMJj+CP2y+XQJzyfj1IEZYYh48RXu57XwJqg67GDZZBPEs8l+sWfpCl+9n4fDl0ydmZHS7ZXHKGPMX9spSPAhsJ0W0WS1MBsgNsa68tmL8Q1r6cJmxnJe8N4+ug/6X43SP87JaSrFr48s2F/OBzYNRpaNATE62bNaim/X9znbaUC5FAetGM47QjivvJT3zL3HtkX8XVYyB4XJ5Nw3FNcbyVqZ82UW/XKrHkMTLyQK2iQvhT3oM01kSr3zajOW6WcgZOJFeSBo7tzM/AEf2isKzSsPWAlwQzMc8W5GCU5kzw2fD/gvH7pem9j5tNF/1d4b6U1qiHOVynnEpIP73zIXjTqNrvHoYnMAJCiST9bl2RVfA3JlsJ72xMuNXiaMSxantJvWntDJ9sEUDB4YYyXKorXU6QCaTnLsdP/5//WkfVoguRa/zUirj1VLZTHrlOPL+mpAlZan6D6oao6X4kayzB4ehA3t75EcO0iEHbmqYQTuaIHygkgNaGtBRxcUuDnempoPani3qycB75keKAxBNWYxAic7MP0NJYBnM9yCf23Sdv5nIV1E/OGzjx1Ewlt4JwbnoTJ6LBb6ZJeONp5QQfFKS8teux029r65LW5p9A189b7PEQXqijh7zpVMjVzy7CIoTXF3qnZS5JJiNztpR9GHnvjI5m/kXMYIdxSdfI/i9yUC1sXOtC7F9alCaGHMZGOdW0tRwp4s4HWsrmls0R4Nn5HZtrs+9uYN+qZA3uF7QfE4ha8gb2wXPp6A6GatSwesDLeA/00ZWpeNAuLA0HB8BlXdVU3uXSsWkIK1gwa9sgSknLys+TN/+HEwZ8z85roa7 GoogleDevFestBangkok202401234567 V+h6liXS+TkCMK5PWh4CzQ==
