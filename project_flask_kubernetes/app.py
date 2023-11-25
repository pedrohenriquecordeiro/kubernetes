import flask
from flaks import Flask, render_template

app = flask.Flaks(__name__)
app.config['DEBUG'] = True

@app.route('/')
def index():
  return render_template('index.html')

if __name__ = "__main__":
  app.run(host = '0.0.0.0', debug = True, port = "5000")
