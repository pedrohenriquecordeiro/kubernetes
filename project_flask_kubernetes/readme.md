#### Comandos a serem executados

``` docker build -t pedrojjesus/flask-kubernetes-project . ```

``` docker run -d -p 5000:5000 --name flask-k8s --rm pedrojjesus/flask-kubernetes-project ```

``` docker login ```

``` docker push pedrojjesus/flask-kubernetes-project ```
