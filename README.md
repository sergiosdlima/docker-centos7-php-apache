# Docker CentOS 7 Apache PHP

Imagem docker CentOS 7 que vem instalado:
* Apache 2.4
* PHP 5.6
* Composer
* Drush 6

## Criar a imagem

  docker build -t NOME-DA-IMAGEM .

## Criar um container a partir da imagem

  docker run -d -p 80:80 -v PASTA-CONTEUDO:/var/www/html NOME-DA-IMAGEM

## Repositório

  Você também pode baixar esta imagem do repositório de desenvolvimento, basta digitar:

  docker pull 10.61.12.8:5000/centos7-php:5.6-apache2.4
