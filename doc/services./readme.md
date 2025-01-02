# Entendendo Services no Kubernetes

No Kubernetes, Services são recursos essenciais para garantir a comunicação estável entre aplicações, mesmo diante das dinâmicas operações de um cluster. 
Eles abstraem a comunicação com os Pods, que possuem endereços IP não estáticos e podem ser recriados constantemente. 
Dessa forma, os Services fornecem uma maneira confiável de acessar aplicações em execução, sem depender diretamente do IP dos Pods.

## O Papel dos Services e ClusterIP

O Service no Kubernetes age como um intermediário, conectando o tráfego de rede a um ou mais Pods que compartilham características comuns. 
No YAML, vemos o Pod web-pod, que possui dois containers: um servidor Apache e um servidor Tomcat, expostos pelas portas 80 e 8080, respectivamente. 
Esses dois containers compartilham o mesmo IP dentro do Pod, mas suas portas são distintas.

Para que outros componentes do cluster acessem o servidor Tomcat no Pod web-pod, foi criado o Service chamado frontend-service. 
Este Service foi configurado com o tipo ClusterIP, que é o padrão no Kubernetes e disponibiliza a comunicação apenas dentro do cluster. 
Assim, o frontend-service permite que qualquer Pod no cluster envie tráfego para o servidor Tomcat de forma consistente, sem precisar saber o IP atual do Pod.

```yaml
# Definição do Pod
apiVersion: v1  # Versão da API utilizada para criar o recurso.
kind: Pod  # Tipo do recurso, neste caso, um Pod.
metadata:
  name: web-pod  # Nome do Pod, único dentro do namespace.
  labels:
    type: web-app  # Rótulo usado para identificar e agrupar o Pod.
spec:
  containers:  # Lista de containers que serão executados dentro do Pod.
    - name: web-server-apache  # Nome do primeiro container no Pod.
      image: httpd  # Imagem do container, que executa um servidor Apache.
      ports:
        - containerPort: 80  # Porta exposta pelo servidor Apache dentro do container.
    - name: web-server-tomcat  # Nome do segundo container no Pod.
      image: tomcat  # Imagem do container, que executa um servidor Tomcat.
      ports:
        - containerPort: 8080  # Porta exposta pelo servidor Tomcat dentro do container.

---

# Definição do Service
apiVersion: v1  # Versão da API utilizada para criar o recurso.
kind: Service  # Tipo do recurso, neste caso, um Service.
metadata:
  name: frontend-service  # Nome do Service, usado para identificá-lo dentro do namespace.
spec:
  type: ClusterIP  # Tipo do Service, que permite acesso interno no cluster.
  selector:
    type: web-app  # Seleciona Pods com o rótulo `type: web-app`.
  ports:
    - name: http  # Nome do mapeamento de porta, usado apenas como referência.
      port: 80  # Porta exposta pelo Service para acesso dentro do cluster.
      targetPort: 8080  # Porta no container (Tomcat) que receberá o tráfego encaminhado pelo Service.
```



### Comunicação com Port e TargetPort

Os campos **port** e **targetPort** são essenciais na configuração de um Service. 
O **port** é a porta exposta pelo **Service**, ou seja, é onde ele estará acessível para os consumidores no cluster. 
No YAML, o *frontend-service* está configurado para ouvir na porta 80. 
Já o **targetPort** especifica para qual porta do container o tráfego será encaminhado. 
Nesse caso, o tráfego que chega na porta 80 do Service será redirecionado para a porta 8080 no servidor Tomcat, dentro do web-pod.

Essa configuração permite que diferentes containers no mesmo Pod sejam acessados por meio de Services, mesmo que compartilhem o mesmo IP. 
É um mecanismo importante para gerenciar múltiplos aplicativos em um único Pod.

## Pods com IP Dinâmico e o Kube DNS

No Kubernetes, os Pods têm IPs dinâmicos, o que significa que, quando um Pod é recriado, ele pode receber um novo endereço IP. Isso pode causar problemas de comunicação se outros componentes dependessem diretamente do IP. É aqui que entra o servidor DNS interno do Kubernetes, conhecido como Kube DNS. Quando um Service é criado, ele recebe automaticamente um nome DNS, que resolve o IP atual dos Pods associados a ele.

Por exemplo, no YAML, o frontend-service foi configurado para selecionar Pods com a label type: web-app. Mesmo que o Pod web-pod seja reiniciado e seu IP mude, o frontend-service continuará encaminhando o tráfego corretamente para ele. Isso garante uma comunicação estável e simplificada dentro do cluster.

## Conclusão

Os Services no Kubernetes são fundamentais para gerenciar a comunicação entre Pods e outros componentes, abstraindo a complexidade de IPs dinâmicos e múltiplos containers. No exemplo fornecido, o Service frontend-service com tipo ClusterIP permite que outros Pods no cluster acessem o servidor Tomcat no web-pod pela porta 8080, enquanto oferece uma interface consistente na porta 80. A combinação de campos como port e targetPort e o suporte do Kube DNS tornam os Services uma peça-chave na arquitetura robusta e escalável do Kubernetes.
