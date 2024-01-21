O **modo declarativo** é guiado por um arquivo yaml.

## Chaves mais utilizadas
 - apiVersion: versão utilizada da ferramenta
 - kind: tipo do arquivo (Deployment, Service)
 - metadata: descrever algum objeto, inserindo chaves como name
 - replicas: número de réplicas de Nodes/Pods
 - containers: definir as especificações de containers como: nome e imagem

-------
Com o arquivo .yaml criado podemos executar o Deployment e/ou criar o Service : ```kubectl apply -f file.yaml```

Stopa o Deployment e/ou criar o Service  (deleta os pods e os services) : ```kubectl delete -f file.yaml```
