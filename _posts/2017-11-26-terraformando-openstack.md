---
title:  "[PT] Terraform – IaC – Terraformando no OpenStack"
last_modified_at: 2017-11-26T16:00:58-04:00
tags:
  - openstack
  - iac
  - terraform
  - pt
  - redhat
  - series
toc: true
toc_sticky: true
---

> Originally published at [**Churrops on DevOps**](https://churrops.io/2017/11/26/terraform-iac-terraformando-no-openstack/) on November 26, 2017.

Olá pessoal, vamos começar uma uma série de artigos sobre OpenStack dando continuidade aos artigos sobre Terraform ([parte 1](https://churrops.io/2017/08/01/terraform-iac-infra-como-codigo-conhecendo/) e [parte 2](https://churrops.io/2017/08/03/terraform-iac-terraformando-na-aws/)) do [Rodrigo Floriano](https://churrops.io/about-authorsrdglinux/), pois é uma ferramenta que vários assíduos do blog já conhecem e usam a diário!

Hoje vamos mostrar um exemplo prático de uso da ferramenta sobre OpenStack.

OpenStack é um *software* de código aberto para a instalação, configuração e gerenciamento de nuvens, tanto públicas como privadas. Rackspace e Dreamhost são alguns exemplos de nuvens públicas que funcionam sobre OpenStack, e PayPal e eBay são exemplos de empresas que usam OpenStack nas suas nuvens privadas.

OpenStack apresenta seus serviços através de APIs compatíveis com os serviços EC2, S3 e CloudFormation da Amazon AWS e, portanto, aplicações escritas para estes serviços do AWS podem ser usados com OpenStack também. Além disso, podemos interagir com  OpenStack via CLI, usando o comando `openstack`, ou pelo *dashboard* da plataforma, o Horizon.

Sem mais, vamos la!

## Pré requisitos
 - Ter o `git` instalado
 - Uma conta em alguma nuvem OpenStack, não necessariamente `admin`
 - Quota suficiente na nossa conta para instanciar os recursos solicitados
 - Ter o Terraform instalado (ver [[Terraform] – IaC – Infra como Código – Conhecendo](https://churrops.io/2017/08/01/terraform-iac-infra-como-codigo-conhecendo/))

## Clonando o repósitorio

```
$ git clone https://github.com/josecastillolema/churrops.git
```

Segue uma breve descrição dos arquivos:

 - **live.tf**
   Arquivo principal, é um *template* com as informações do *provider* (neste caso OpenStack) e a topologia dos recursos que vão ser criados. No primeiro bloco definimos as credencias de acesso a nossa nuvem OpenStack:
   ```
   provider "openstack" {
      user_name   = "jose.castillo"
      tenant_name = "churrops"
      tenant_id   = "ddc494sdfc8bc6ba7caf6d3615b"
      password    = "password"
      auth_url    = "https://keystone.openstack.com.br:5000/v2.0"
   }
   ```
   Para conseguir o `tenant_id` do projeto churrops (o *id* do nosso projeto) basta executar `openstack project show churrops` ou `openstack project list | grep churrops` (ou pegar os dados via o *dashboard* de OpenStack, Horizon).

   No segundo bloco definimos alguns valores que vamos usar no projeto, como a imagem (neste caso Ubuntu), a chave (caso precisemos acessar por ssh a instância), o *flavor*, as redes, etc. Este bloco não é obrigatório, mas pode facilitar a nossa vida quando trabalhemos com um número maior de instâncias. Neste exemplo estamos usando o *security group* padrão do OpenStack (a porta 80 precisa estar aberta), mas de forma muito direta poderíamos criar um recurso de tipo *security group* personalizado para o nosso servidor web. O [site da Terraform](https://www.terraform.io/docs/providers/openstack/) mostra todos os recursos que temos disponíveis para OpenStack.

   ```
   variable "defaults" {
      description = "Variaveis do projeto"
      type = "map"
      default {
         image_name = "linux-ubuntu-16-64b-base"
         az_name = "nova"
         region = "SP"
         tenant_name = "churrops"
         key_pair = "chave"
         flavor_name = "g1.micro"
         security_group = "default"
         network_name = "rede-interna"
      }
   }
   ```

   No terceiro bloco definimos o nosso servidor web. Na variável `user_data` apontamos para outro arquivo do exemplo, que vai ser executado via **cloud-init** no primeiro *boot* para configurar o servidor web.
   ```
   resource "openstack_compute_instance_v2" "web" {
      name = "web"
      image_name = "${var.defaults["image_name"]}"
      flavor_name = "${var.defaults["flavor_name"]}"
      availability_zone = "${var.defaults["az_name"]}"
      key_pair = "${var.defaults["key_pair"]}"
      security_groups = ["${var.defaults["security_group"]}"]
      network {
         name = "${var.defaults["network_name"]}"
      }
      user_data = "${file("bootstrapweb.sh")}"
      lifecycle {
         create_before_destroy = true
      }
   }
   ```

   Por último, os restantes blocos associam uma IP pública ao nosso servidor web:
   ```
   resource "openstack_networking_floatingip_v2" "ip-publica" {
      pool = "rede-publica"
   }

   resource "openstack_compute_floatingip_associate_v2" "asoc-ip-publica" {
      floating_ip = "${openstack_networking_floatingip_v2.ip-publica.address}"
      instance_id = "${openstack_compute_instance_v2.web.id}"
   }
   ```

 - **output.tf**
Retorna o IP público da instância do nosso servidor web.

 - **bootstrapweb.sh**

Arquivo de *shell* que vai ser executado via **cloud-init** no primeiro *boot* para configurar o servidor web. Esta versão é para SOs de tipo Debian, mas pode ser fácilmente modificada para funcionar em CentOS e derivados.

## Fazendo o *deploy*

```
$ terraform init
```

![](/assets/images/posts/2017-11-26-terraformando-openstack/01.png)

```
$ terraform plan
```
```
$ terraform apply
```
![](/assets/images/posts/2017-11-26-terraformando-openstack/02.png)

Se tudo der certo, veremos a nova VM com a sua IP pública correspondente:

![](/assets/images/posts/2017-11-26-terraformando-openstack/03.png)

E conseguimos acessar ao nosso *site*:

![](/assets/images/posts/2017-11-26-terraformando-openstack/04.jpeg)


## Outros comandos
O resto dos comandos que foram explicados [no caso da AWS](https://churrops.io/2017/08/03/terraform-iac-terraformando-na-aws/), `terraform graph`, `terraform show` e `terraform destroy` funcionam de forma idêntica em OpenStack.

## Conclusão
Terraform se integra muito bem com vários provedores de nuvem, incluíndo OpenStack! Neste artigo vimos como é simples integrar OpenStack com a ferramenta, e como a mesma funciona de forma coerente entre várias nuvens.

Nos [próximos artigos](/heat-introducao) de OpenStack falaremos sobre *heat*, o “terraform” nativo da plataforma, e veremos como é simples também gerenciar o ciclo de vida de *hardware* e *software* usando o orquestrador nativo da nuvem.

Obrigado a todos e um abraço!



