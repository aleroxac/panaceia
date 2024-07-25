# panaceia
Plataforma para servir times de desenvolvimento e infraestrutura a fim de gerar acessos, templates e recursos de infraestrutura.


## Recursos
- Cloud Providers suportados:
    - gcp
- Plataformas de orquestração de containers suportadas:
    - kubernetes
- Ferramentas de provisionamento de infraestrutura suportadas:
    - terraform
- Recursos de infraestrutura: 
    - github: repositórios
    - mongodbatlas: mongodb
    - cloudamqp: rabbitmq
    - gcp: redis, postgresql, external-static-ip
    - cloudflare: fqdns
- Templates:
    - dockerfile
    - docker-compose
    - makefile
    - manifestos do kubernetes
    - helm charts do kubernetes
    - jenkinsfile
- Acessos:
    - gcp
    - github
    - cloudamqp
    - mongodbatlas


---
## Módulos
- **publisher:** API capaz receber as definições dos projetos a serem criados e publicá-los em uma fila do rabbitmq
- **worker:** Consumidor que processa as mensagens do rabbit e gera os acessos, templates e recursos de infra
- **notify:** API capaz de mandar notificações via slack


---
## Fluxo do app
    1. api:payload > REST API recebe as definições de novos projetos
    2. mongodb:payload > armazena solicitação em um mongodb
    3. rabbitmq:order[payload] > encaminha mensagem com o payload para uma fila de pedidos no rabbitmq
    4. slack:sre > notifica time de sre via slack
    5. api:approve > aguarda aprovação via chamada na api para criação de recursos
    6. mongodb:order[status=approved] > altera o status do pedido para aprovado
    7. slack:dev > notifica dev via slack
    8. mongodb:task > armarzena task em um mongodb
    9. rabbitmq:task[resources] > encaminha mensagem com os resources para uma fila no rabbitmq
    10. k8s:job[configmap] > preenche o template de configmap para o job
    11. k8s:job[secret] > preenche o template de secret para o job
    12. k8s:job[automation=resources] > executa job no k8s capaz de gerar recursos de infra solicitados
    14. k8s:job[automation=templates] > executa job no k8s capaz de gerar templates solicitados
    15. mongodb:task[status=done] > altera o status da task para finalizado
    16. slack:dev > notifica dev via slack


---
## Funcionalidades
### mktemplate
    - Automação para gerar e validar Dockerfiles
        - estrutura
            - criar arquivo de config
            - definir imagem base
            - validar build-args
            - instalar dependencias
            - criar pasta do workenv
            - copiar artefatos do app
            - ciar user e group para o app
            - mudar a permissão dos arquivos
            - setar o entrypoint/cmd
            - expor as portas
            - setar healthcheck
        - linguagens
            - python
                - python-flask
                - python-django
            - java
                - java-maven
                - java-gradle
        - segurança
            - dont use root user
            - create a app user
            - create a app group
            - change file owner and permissions
        - tamanho da imagem
            - install only if needed
            - use && instead multiple RUN commands
            - use .dockerignore to mange build context
        - build-args
            - arg
            - env
        - multi-staging
            - define base images
            - copy generated files between stages
        - linter
            - DOCKER_BUILDKIT=1
            - hadolint
        - testes
            - docker run
            - curl
            - ab

    - Automação para gerar e validar docker-compose.yml
        - services
            - build
            - image
            - environment
            - healthchecks
            - depends_on
            - ports
        - volumes
            - secrets
            - mount-points
            - host-volumes
        - networks
            - internal
            - external
        - testes
            - docker run
            - curl
            - ab

    - Automação para gerar e validar Makefiles
        - init
        - prepare
        - build_code
        - build_image
        - up
        - down
        - clean
        - lint
        - test
        - 

    - Automação para gerar e validar manifestos do k8s
        - namespace
        - data
            - configmap
            - secret
        - deploy
            - deployment
            - hpa
        - network
            - service
            - certificate
            - ingress
            - backend-config

    - Automação para gerar e validar helm charts para o k8s
        - namespace
        - data
            - configmap
            - secret
        - deploy
            - deployment
            - hpa
        - network
            - service
            - certificate
            - ingress
            - backend-config

    - Automação para gerar e validar jenkinsfiles
        - envs
        - commands
        - jobs
        - workflows
### mkinfra
    - Automação para gerar cluster no cloudamqp
    - Automação para gerar cluster no atlas-mongodb
    - Automação para gerar redis no GCP
    - Automação para gerar DB no GCP
    - Automação para gerar external-static-ip no GCP
    - Automação para gerar FQDN no Cloudflare
    - Automação para gerar repositórios no Github
### mkaccess
    - gcp
    - github
    - cloudamqp
    - mongodbatlas