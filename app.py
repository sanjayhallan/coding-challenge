from flask import Flask
app = Flask(__name__)

def hello_world():
    return 'Hello, World!'

@app.route('/')
def root_route():
    return hello_world()