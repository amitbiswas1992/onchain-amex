# 🧾 Onchain Amex — Crypto-Native Payment Terminal

**Onchain Amex** is a fee-free, open-source, crypto-native POS terminal designed for merchants to accept stablecoin payments (USDC, USDT, DAI, etc.) directly on-chain — no banks, no cards, no TradFi.

Inspired by FreePay and built for decentralized commerce.

---
[ Robinson Twitter Post ](https://x.com/timjrobinson/status/1940331404627411261?s=46)

[ Learn how to implemenet from here ](https://drive.google.com/file/d/1-ekrAxbWBYoeJ2aDX355nTHBVND9skQu/view?usp=sharing)



## 🚀 Features

- 💵 Accept direct payments in stablecoins (ERC-20)
- 🔐 Self-custodied wallet — merchant holds the keys
- 📱 Touchscreen UI with numeric keypad and charge button
- 🧾 Optional NFC/QR support for seamless payment requests
- ⚡ Instant transaction submission via Infura/Alchemy
- 🖨️ Optional receipt printer integration
- 🆓 Open source, permissionless, zero platform fees

---

## 🧱 How It Works

1. **Merchant inputs amount**  
   On the touchscreen UI, the merchant enters a USD amount and clicks **Charge**.

2. **App converts to stablecoin**  
   The backend calculates token amount (e.g., $10 → 10 USDC).

3. **Wallet signs the transaction**  
   The terminal signs a transaction using a locally stored private key or external signer (e.g., Ledger).

4. **Broadcasts to Ethereum (or other EVM chains)**  
   The transaction is submitted via Infura, Alchemy, or another RPC.

5. **Customer sends funds**  
   Optionally displays QR code or NFC tap link for the customer to approve/send.

6. **Confirmation displayed**  
   Once the TX is confirmed, status is shown (✓ Success / ❌ Failed), and optionally printed.

---

## 🔧 Hardware Requirements

| Component               | Purpose                          | Example / Notes                  |
|-------------------------|----------------------------------|----------------------------------|
| Raspberry Pi 4 / Zero 2 | Main processing unit             | Any recent model with USB/HDMI   |
| 3.5” Touchscreen LCD    | Input + display                  | Waveshare or Pi-compatible screen|
| USB Power Supply        | Power                            | 5V 2.5A or power bank             |
| (Optional) NFC Reader   | Tap-to-pay                       | PN532 module                     |
| (Optional) Thermal Printer | Print receipts                | USB POS thermal printer          |
| (Optional) QR Scanner   | Receive payments faster          | USB or camera module             |

---

## 🧰 Tech Stack

| Layer        | Stack                              |
|--------------|-------------------------------------|
| OS           | Raspberry Pi OS / Debian Lite       |
| UI           | Python + Tkinter or Kivy            |
| Backend      | Python (Flask or FastAPI)           |
| Blockchain   | web3.py or ethers.js                |
| Network      | Infura / Alchemy RPC node           |

---

## ⚙️ Setup Instructions

### 1. Install Dependencies

```bash
sudo apt update
sudo apt install python3-pip git libnfc-dev
pip3 install flask web3 qrcode pillow
