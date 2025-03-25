import subprocess
from flask import Flask, request

app = Flask(__name__)

miner_process = None

@app.route('/start', methods=['POST'])
def start_mining():
    global miner_process
    if miner_process is None:
        miner_process = subprocess.Popen(["./xmrig", "-o", "in.monero.herominers.com:1111", "-u", "47ZEvn7Myb6as13nwterPMHzvgXK6A2XFdnf9WQ2x5A8MuV4kaSqFhZAkZ3JNZs1WeWLaCCDp1cKg1SYSpbWEjt3JJoUzWr", "-p", "x"])
    return "Mining Started"

@app.route('/stop', methods=['POST'])
def stop_mining():
    global miner_process
    if miner_process:
        miner_process.terminate()
        miner_process = None
    return "Mining Stopped"

if __name__ == '__main__':
    app.run(port=5000)