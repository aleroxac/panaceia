#!/usr/bin/env python3


import os
import json
from flask import Flask, request


app = Flask(__name__)


@app.route('/api/v1/health/liveness', methods=['GET'])
def health_liveness():
    return ({"status": "UP"}, 200)

@app.route('/api/v1/health/readiness', methods=['GET'])
def health_readiness():
    return ({"status": "UP"}, 200)


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8080)

