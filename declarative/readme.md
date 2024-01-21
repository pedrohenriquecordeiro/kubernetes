O **modo declarativo** é guiado por um arquivo yaml.

### Chaves mais utilizadas
 - apiVersion: versão utilizada da ferramenta
 - kind: tipo do arquivo (Deployment, Service)
 - metadata: descrever algum objeto, inserindo chaves como name
 - replicas: número de réplicas de Nodes/Pods
 - containers: definir as especificações de containers como: nome e imagem

## Criando Deployments e Services
Com o arquivo .yaml criado para o Deployment podemos executar o Deployment com : ```kubectl apply -f file-deployment.yaml```

Com o arquivo .yaml criado para o Service podemos criar o Service executando o mesmo comando : ```kubectl apply -f file-service.yaml```

## Stop de Deployments e Services
Para stopar o Deployment e/ou o Service usamos o comando : ```kubectl delete -f file.yaml```

## Atualizando projeto
1. Primeiramente vamos criar uma nova versão da imagem Docker
2. Fazer o push para o Hub
3. Alterar no arquivo de Deployment para apontar para nova imagem
4. Executar o apply apenas para o Deployment
5. Atualizado !!
