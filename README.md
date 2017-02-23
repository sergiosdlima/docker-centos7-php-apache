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
