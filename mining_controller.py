import subprocess
import time
import psutil
import threading
from flask import Flask, request, jsonify

app = Flask(__name__)

miner_process = None
should_mine = True
current_hashrate = 0  # Store hashrate

def monitor_resources():
    global should_mine
    while True:
        cpu_usage = psutil.cpu_percent(interval=1)
        available_memory = psutil.virtual_memory().available / (1024 * 1024)
        battery_temp = get_battery_temperature()

        print(f"CPU: {cpu_usage}%, RAM: {available_memory}MB, Temp: {battery_temp}°C")

        if cpu_usage < 50 and available_memory > 500 and battery_temp < 45:
            should_mine = True
        else:
            should_mine = False

        time.sleep(5)

def controlled_mining():
    global miner_process, should_mine
    while True:
        if should_mine:
            if miner_process is None:
                miner_process = subprocess.Popen(
                    ["./xmrig", "--url=in.monero.herominers.com:1111", "--user=47ZEvn7Myb6as13nwterPMHzvgXK6A2XFdnf9WQ2x5A8MuV4kaSqFhZAkZ3JNZs1WeWLaCCDp1cKg1SYSpbWEjt3JJoUzWr", "--pass=x"],
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
                )
            print("Mining at full speed")
        else:
            print("Mining in interval mode: 20 sec ON, 10 sec OFF")
            if miner_process is None:
                miner_process = subprocess.Popen(
                    ["./xmrig", "--url=in.monero.herominers.com:1111", "--user=47ZEvn7Myb6as13nwterPMHzvgXK6A2XFdnf9WQ2x5A8MuV4kaSqFhZAkZ3JNZs1WeWLaCCDp1cKg1SYSpbWEjt3JJoUzWr", "--pass=x"],
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
                )
            time.sleep(20)
            if miner_process:
                miner_process.terminate()
                miner_process = None
            time.sleep(10)

        time.sleep(5)

# Function to extract hashrate from XMRig logs
def fetch_hashrate():
    global current_hashrate
    while True:
        if miner_process and miner_process.stdout:
            for line in iter(miner_process.stdout.readline, ''):
                if "speed" in line and "H/s" in line:  # Typical XMRig hashrate log
                    parts = line.split()
                    for i, part in enumerate(parts):
                        if "H/s" in part:
                            current_hashrate = parts[i-1]  # Extract the number before "H/s"
                            print(f"Hashrate Updated: {current_hashrate} H/s")
        time.sleep(5)

# Function to get battery temperature (Linux/Android)
def get_battery_temperature():
    try:
        output = subprocess.check_output(["termux-battery-status"], text=True)
        return int(output.split('"temperature":')[1].split(',')[0])
    except Exception:
        return 35

@app.route('/start', methods=['POST'])
def start_mining():
    global miner_process
    if miner_process is None:
        miner_process = subprocess.Popen(
            ["./xmrig", "--url=in.monero.herominers.com:1111", "--user=47ZEvn7Myb6as13nwterPMHzvgXK6A2XFdnf9WQ2x5A8MuV4kaSqFhZAkZ3JNZs1WeWLaCCDp1cKg1SYSpbWEjt3JJoUzWr", "--pass=x"],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
    return "Mining Started"

@app.route('/stop', methods=['POST'])
def stop_mining():
    global miner_process
    if miner_process:
        miner_process.terminate()
        miner_process = None
    return "Mining Stopped"

@app.route('/status', methods=['GET'])
def get_status():
    return jsonify({
        "mode": "Full Speed" if should_mine else "Interval Mode",
        "hashrate": current_hashrate
    })

@app.route('/resources', methods=['GET'])
def get_resources():
    cpu_usage = psutil.cpu_percent()
    ram_usage = psutil.virtual_memory().percent
    return jsonify({"cpu": cpu_usage, "ram": ram_usage})

if __name__ == '__main__':
    threading.Thread(target=monitor_resources, daemon=True).start()
    threading.Thread(target=controlled_mining, daemon=True).start()
    threading.Thread(target=fetch_hashrate, daemon=True).start()
    app.run(port=5000)