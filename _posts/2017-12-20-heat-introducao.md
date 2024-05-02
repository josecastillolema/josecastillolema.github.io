---
title:  "[PT] Heat - Introdução"
last_modified_at: 2017-10-28
tags:
  - iac
  - openstack
  - pt
  - redhat
  - series
toc: true
toc_sticky: true
---

> Originally published at [**Churrops on DevOps**](https://churrops.io/2017/12/20/heat-introducao/) on December 20, 2017.

Olá pessoal, vamos começar uma série de artigos sobre Heat, o “terraform” nativo do OpenStack, ou para quem vem do mundo da AWS, o CloudFormation do OpenStack (inclusive parcialmente compatível). Neste primeiro artigo introdutório vamos aprender a criar as nossas próprias pilhas (ou *stacks*) e recriar a instância do servidor web que criamos no [post passado](/terraformando-openstack) usando o Terraform.

O objetivo principal de Heat é criar um serviço para gerenciar todo o ciclo de vida de infra e aplicativos dentro do OpenStack. Ele implementa um mecanismo de orquestração com base em *templates* na forma de arquivos de texto (em formato `.yaml`) que podem ser tratados como código. O formato dos `templates` está evoluindo a cada versão do OpenStack, mas o Heat se esforça para fornecer compatibilidade com o formato do modelo AWS CloudFormation, de modo que muitos modelos CloudFormation existentes podem ser iniciados no OpenStack (inclusive permitindo, por exemplo, escalar do OpenStack para dentro da AWS). Para quem tiver interesse, existe também um esforço da comunidade para suportar templates TOSCA, chamado [Heat Translator](https://wiki.openstack.org/wiki/Heat-Translator).

O Heat fornece uma API REST nativa do OpenStack e uma API de consulta compatível com o CloudFormation, além de interface gráfica via Horizon (o *dashboard* de OpenStack) e um cliente para a linha de comandos (antigamente `heat`, nas versões mais novas de OpenStack foi integrado no próprio comando `openstack`).

Uma característica importante do Heat é que ele gerencia todo o ciclo de vida do aplicativo, e não só a criação. Quando precisar alterar a infra, simplesmente modifique o modelo e use o Heat para atualizar sua pilha existente. Heat sabe como fazer as mudanças necessárias. Ele irá excluir todos os recursos quando você terminar o aplicativo também (tipo `terraform destroy`).

Os recursos de infra que podem ser descritos incluem: instâncias, IPs públicos, volumes, grupos de segurança, usuários, roteadores, etc. Os modelos também podem especificar as relações entre recursos (por exemplo, este volume está conectado a este servidor). Isso permite que o Heat invoque as APIs do OpenStack para criar toda sua infra virtual na ordem correta para iniciar completamente sua aplicação.

O Heat também se integra com o Ceilometer, o módulo de telemetria do OpenStack, permitindo definir políticas de uso de *autoscaling* em função do uso dos recursos (chegaremos lá nos próximos artigos!).

O Heat gerencia principalmente a infra virtual, mas os modelos se integram bem com ferramentas de gerenciamento de configuração de *software*, como Puppet e Chef, e a equipe do Heat está trabalhando para fornecer uma integração ainda melhor entre infraestrutura e *software*. Existem várias opções para configurar o software que é executado nos servidores do *stack*:
 - Criar uma imagem personalizada (de preferência usando [**diskimager-builder**](https://git.openstack.org/cgit/openstack/diskimage-builder))
 - Via [**cloud-init**](https://cloud-init.io/), um script que é executado durante o primeiro boot. Esta será a forma que usaremos ao longo dos artigos.
 - Um recurso do heat, de tipo ***software deployment***.

Sem mais, vamos criar o nosso primeiro *stack* e recriar o nosso servidor web.

## Pré requisitos

 - Uma conta em alguma nuvem OpenStack, não necessariamente `admin`
 - Quota suficiente na nossa conta para instanciar os recursos solicitados

No repositório [https://github.com/josecastillolema/churrops.git](https://github.com/josecastillolema/churrops.git) podem fazer *download* do arquivo heat.yaml, o *template* que usaremos durante este artigo.

## Descrição do *template*
As duas primeras linhas mostram a versão em uso do formato do template e uma descrição do conteúdo do mesmo:
```yaml
heat_template_version: 2016-04-08
description: Servidor web para churrops!
```

A seguir, o primeiro bloco do *template*, `parameters`, define uma série de parâmetros que serão usados durante o *deployment* da infra (de forma análoga ao bloco `variable` no caso do Terraform). Podemos definir neste bloco imagem, *flavor*, redes, chaves para acessar aos nossos servidores, etc. Para cada parâmetro definido podemos adicionar uma descrição e um valor padrão.
```yaml
parameters:
  flavor:
    type: string
    description: Flavor para o servidor web
    constraints:
    - custom_constraint: nova.flavor
    default: g1.micro
  image:
    type: string
    description: Imagem para o servidor web
    constraints:
    - custom_constraint: glance.image
    default: linux-ubuntu-16-64b-base
  private_network:
    type: string
    description: Rede interna
    constraints:
    - custom_constraint: neutron.network
    default: net-int1
  private_ip:
    type: string
    description: IP interna do servidor
    default: 10.0.0.200
  key_name:
    type: string
    description: A chave ssh para acessar a nossa vm
    constraints:
    - custom_constraint: nova.keypair
    default: devel
  public_network:
    type: string
    description: Rede publica
    constraints:
    - custom_constraint: neutron.network
  texto:
    type: string
    description: Texto exibido no site
    default: "Churrops rules"
```
No segundo bloco, `resources`, é a onde vamos definir os recursos da nossa infra. Neste caso vamos definir o nosso servidor web. Podem consultar uma lista de todos os recursos disponíveis [aqui](https://docs.openstack.org/heat/pike/template_guide/openstack.html). O servidor web é configurado via **cloud-init** no primeiro *boot*. Vejam que é possível passar parâmetros para os recursos, como neste caso o parâmetro `TEXTO`.
```yaml
resources:
  sec_group:
    type: OS::Neutron::SecurityGroup
    properties:
      rules:
      - remote_ip_prefix: 0.0.0.0/0
        protocol: icmp
      - remote_ip_prefix: 0.0.0.0/0
        protocol: tcp
        port_range_min: 80
        port_range_max: 80
      - remote_ip_prefix: 0.0.0.0/0
        protocol: tcp
        port_range_min: 22
        port_range_max: 22 

  serverweb_port:
    type: OS::Neutron::Port
    properties:
      network_id: { get_param: private_network }
      security_groups: [{ get_resource: sec_group }]

  serverweb:
    type: OS::Nova::Server
    properties:
      image: { get_param: image }
      flavor: { get_param: flavor }
      networks:
        - port: { get_resource: serverweb_port }
      user_data_format: RAW
      key_name: { get_param: key_name }
      user_data:
        str_replace:
          template: |
            #!/bin/bash
            sudo -i
            apt-get update
            apt-get install -y apache2
            cat < /var/www/html/index.html
            Churrops!!! o/
            hostname: $(hostname)
            parametro: TEXTO
            EOF
          params:
            TEXTO: { get_param: texto }

  floating_ip:
    type: OS::Neutron::FloatingIP
    properties:
      floating_network: { get_param: public_network }
      port_id: { get_resource: serverweb_port }
```
O terceiro e ultimo bloco, `outputs`, tem uma função análoga ao arquivo `output.tf` do Terraform. Ele define uma saída que será mostrada ao usuário ao terminar a criação da infra.
```yaml
outputs:
  lburl:
    description: URL do servidor web
    value:
      str_replace:
        template: http://IP_ADDRESS
        params:
          IP_ADDRESS: { get_attr: [ floating_ip, floating_ip_address ] }
    description: >
      Esta URL e a URL "externa" que pode ser usada para acessar o servidor WEB.
```

## Execução do *template*

### Via Horizon
Primeiro, na aba `Orquestration - Stacks` criamos o nosso *stack* e setamos os parâmetros opcionais que foram definidos no template.
![](/assets/images/posts/2017-12-20-heat-introducao/01.png)

A continuação podemos ver a topologia diversos recursos sendo criados (os recursos em verde já estão disponíveis).
![](/assets/images/posts/2017-12-20-heat-introducao/02.png)

Um *overview* da nossa pilha, com o *output* que definimos no *template*.
![](/assets/images/posts/2017-12-20-heat-introducao/03.png)

Os recursos que estão sendo criados.
![](/assets/images/posts/2017-12-20-heat-introducao/04.png)

E por último todos os eventos relacionados com esses recursos (criação, atualização, modificação, deleção, etc.).
![](/assets/images/posts/2017-12-20-heat-introducao/05.png)

### Via CLI
 - Criação:
   ```
   openstack stack create churrops-stack -t heat.yaml
   openstack stack create churrops-stack -t heat.yaml
   ```

 - Para acompanhar a criação:
   ```
   watch openstack stack event list churrops-stack

   ```

### Via API REST
Como falamos na introdução, o Heat fornece uma API REST nativa do OpenStack e uma API de consulta compatível com o CloudFormation. Neste caso usaremos a API REST nativa.

![](/assets/images/posts/2017-12-20-heat-introducao/06.png)


## Resultado da execução

Independentemente do método escolhido (Horizon, CLI ou API REST), uma vez que o *stack* transicione ao estado `created` (não deveria demorar muito mais de 2 minutos) poderemos ver a infra instanciada.
![](/assets/images/posts/2017-12-20-heat-introducao/07.png)

Em alguns minutos (enquanto **cloud-init** instala e configura o servidor web Apache), poderemos acessar ao nosso servidor pela IP pública.
![](/assets/images/posts/2017-12-20-heat-introducao/07.png)


## Conclusão
Neste artigo introduzimos o Heat, o orquestrador do OpenStack. Vimos como mantém todas as funcionalidades de outros IaCs, como Terraform, mas é integrado de uma forma mais nativa no OpenStack e podemos accesá-lo via *dashboard*	, linha de comandos ou API REST (compatível com a AWS CloudFormation).

Nos próximos artigos veremos como criar via Heat um balanceador de carga em alta disponibilidade usando `haproxy` e VRRP.

Um abraço!
