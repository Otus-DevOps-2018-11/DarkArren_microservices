# DarkArren_microservices

DarkArren microservices repository

<details>
  <summary>HomeWork 14 - Технология контейнеризации. Введение в Docker</summary>

## HomeWork 14 - Технология контейнеризации. Введение в Docker

- Настроена интегерация с Slack и Travis CI
- Установлен docker
- Запущен контейнер hello-world

```bash
docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:2557e3c07ed1e38f26e389462d03ed943586f744621577a99efb77324b0fe535
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

- Получен список запущенных контейнеров: docker ps
- Получен список всех контейнеров: docker ps -a
- Получен список всех сохраненный образов: docker images
- Запущен контейнер ubuntu:16.04: docker run -it ubuntu:16.04 /bin/bash
- В запущенном контейнере создан файл /tmp/file
- Контейнер запущен повторно, проверено что файла нет
- Получен список всех запущенных контейнеров с форматирование списка:

```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"

CONTAINER ID        IMAGE               CREATED AT                      NAMES
02bac0c6d6f7        ubuntu:16.04        2019-02-19 15:44:11 +0300 MSK   xenodochial_aryabhata
1305ff58ec3f        ubuntu:16.04        2019-02-19 15:43:53 +0300 MSK   hopeful_hertz
05fbd50e8973        hello-world         2019-02-19 15:33:18 +0300 MSK   nifty_blackwell
```

- Контейнер 1305ff58ec3f перезапущен через docker start 1305ff58ec3f
- Треминал подсоединен к контейнеру через docker attach 1305ff58ec3f
- Проверено наличие файла /tmp/file
- Терминал отсоединен по комбинации "Ctrl + p Ctrl + q"
- Внутри контейнера запущен процесс bash посредством docker exec -it x bash
- Создан образ из запущенного контейнера

```bash
docker commit 1305ff58ec3f darkarren/ubuntu-tmp-file
sha256:454a2224550b87e5bf6c1b3158154e2837dd485f86252148cc82862f7ba5d520

docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
darkarren/ubuntu-tmp-file   latest              454a2224550b        2 minutes ago       117MB
ubuntu                      16.04               7e87e2b3bf7a        3 weeks ago         117MB
hello-world                 latest              fce289e99eb9        7 weeks ago         1.84kB
```

### HW14: Задание со *

- Получена метадата контейнера и образа посредством docker inspect
- На основе изучения метадаты сделаны выводы о различиях между контейнером и образом, выводы описаны в ./docker-monolith/docker-1.log

- Контейнер docker остановлен посредством команды docker kill $(docker ps -q)
- Получена информация об использованном дисковом пространстве посредством docker system df
- Удалены все незапущенные контейнеры: docker rm $(docker ps -a -q)
- Удалены все образы, от которых не зависят запущенные контейнеры: docker rmi $(docker images -q)

</details>

<details>
  <summary>HomeWork 15 - Docker-контейнеры. Docker под капотом</summary>

## HomeWork 15 - Docker-контейнеры. Docker под капотом

- Создан проект новый проект "docker" в GCE
- GCloud SDK настроен на работу с новым проектом
- Получен файл с аутентификационными данным application_default_credentials.json
- Имя проекта в Gogle Cloud добавленно в env: export GOOGLE_PROJECT=docker
- Создан docker host в GCE

```bash
docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-disk-size 20 --google-zone europe-west1-b docker-host

Creating CA: /Users/user/.docker/machine/certs/ca.pem
Creating client certificate: /Users/user/.docker/machine/certs/cert.pem
Running pre-create checks...
(docker-host) Check that the project exists
(docker-host) Check if the instance already exists
Creating machine...
(docker-host) Generating SSH Key
(docker-host) Creating host...
(docker-host) Opening firewall ports
(docker-host) Creating instance
(docker-host) Waiting for Instance
(docker-host) Uploading SSH Key
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env docker-host
```

- Хост успешно создан

```bash
docker-machine ls

NAME          ACTIVE   DRIVER   STATE     URL                       SWARM   DOCKER     ERRORS
docker-host   -        google   Running   tcp://34.76.53.252:2376           v18.09.2
```

- Установлено подключение к docker-host - eval $(docker-machine env docker-host)
- В ./docker-monolith добавлены файлы: mongod.conf, start.sh, db_config, Dockerfile
- Подготовлен Dockerfile содержащий в себе установку зависимостей, конфигурирование MongoDB, установку самого приложения reddit
- Собран docker-образ: "docker build -t reddit:latest ."
- Убеждаемся что образ создался:

```bash
docker images -a

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
reddit              latest              d40ff5ea0214        About a minute ago   678MB
<none>              <none>              aec1e11f589c        About a minute ago   678MB
<none>              <none>              3364bbd5b6ab        About a minute ago   678MB
<none>              <none>              9f496019d63d        About a minute ago   639MB
<none>              <none>              2255bf57572e        About a minute ago   639MB
<none>              <none>              6e2919ea1d40        About a minute ago   639MB
<none>              <none>              fcaa20de4bb7        About a minute ago   639MB
<none>              <none>              554f8d527ce0        About a minute ago   638MB
<none>              <none>              6f69ea8d318d        About a minute ago   636MB
<none>              <none>              9e216306266d        2 minutes ago        142MB
ubuntu              16.04               7e87e2b3bf7a        3 weeks ago          117MB
```

- Запущен контейнер из подготовленного образа

```bash
docker run --name reddit -d --network=host reddit:latest

1d0d10dbe7bbb4d8f7e9380aae524b5d43b3cc96556c172660ad5c59d75046a6
```

- Создано правило для входящего трафика на порт 9292

```bash
gcloud compute firewall-rules create reddit-app \
--allow tcp:9292 \
--target-tags=docker-machine \
--description="Allow PUMA connections" \
--direction=INGRESS

Creating firewall...⠹
Created [https://www.googleapis.com/compute/v1/projects/docker/global/firewalls/reddit-app].
Creating firewall...done.
NAME        NETWORK  DIRECTION  PRIORITY  ALLOW     DENY  DISABLED
reddit-app  default  INGRESS    1000      tcp:9292        False
```

- Приложение доступно по адресу docker-host и порту 9292 - <http://34.76.53.252:9292>

### Работа с Docker Hub

- Образ помечен тэгом darkarren/otus-reddit:1.0 - "docker tag reddit:latest darkarren/otus-reddit:1.0"
- Образ запушен в Docker Hub

```bash
docker push darkarren/otus-reddit:1.0

The push refers to repository [docker.io/darkarren/otus-reddit]
d0ae5e78a45b: Pushed
f37225326dff: Pushed
64925e06bdc7: Pushed
f58213744e0c: Pushed
ceb2f5e8ae0a: Pushed
6a1bb964d3e7: Pushed
4f1fd919d4ef: Pushed
08d3ef9c8c9c: Pushed
30dbb471bf89: Pushed
68dda0c9a8cd: Mounted from library/ubuntu
f67191ae09b8: Mounted from library/ubuntu
b2fd8b4c3da7: Mounted from library/ubuntu
0de2edf7bff4: Mounted from library/ubuntu
1.0: digest: sha256:257ccd84bf0356475bd745f24c210a94b1566122a1db957735c00cc8f16ca674 size: 3034
```

- Проверена возможность запуска из образа, который был запушен на Docker Hub, на локальной машине

```bash
docker run --name reddit -d -p 9292:9292 darkarren/otus-reddit:1.0

Unable to find image 'darkarren/otus-reddit:1.0' locally
1.0: Pulling from darkarren/otus-reddit
7b722c1070cd: Pull complete
5fbf74db61f1: Pull complete
ed41cb72e5c9: Pull complete
7ea47a67709e: Pull complete
2dc168f730c0: Pull complete
af9858bd676f: Pull complete
d0dbc3018af5: Pull complete
a5a479d48608: Pull complete
a210db0f39fa: Pull complete
4629435d8564: Pull complete
0c9423df5de6: Pull complete
9804f03d3491: Pull complete
88f02f1952f9: Pull complete
Digest: sha256:257ccd84bf0356475bd745f24c210a94b1566122a1db957735c00cc8f16ca674
Status: Downloaded newer image for darkarren/otus-reddit:1.0
1ff3c85c7770f4b7868ecfb9b990a93d5990dbd86d44a0b9958404545533c0ad

CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                    NAMES
1ff3c85c7770        darkarren/otus-reddit:1.0   "/start.sh"         12 seconds ago      Up 11 seconds       0.0.0.0:9292->9292/tcp   reddit
```

- Убедился что приложение доступно по <http://127.0.0.1:9292>
- Посмотрел логи контейнера посредством "docker logs reddit -f", убедился что в процессе взаимодейтсвия с приложением логи отображаются
- Зашел в контейнер и вызвал его остановку изнутри

```bash
docker exec -it reddit bash

root@1ff3c85c7770:/# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  18028  2776 ?        Ss   07:32   0:00 /bin/bash /start.sh
root         9  1.5  1.7 555236 36384 ?        Sl   07:32   3:10 /usr/bin/mongod --fork --logpath /v
root        20  0.0  2.1 651052 44556 ?        Sl   07:32   0:11 puma 3.10.0 (tcp://0.0.0.0:9292) [r
root        38  2.7  0.1  18232  3108 pts/0    Ss   10:51   0:00 bash
root        52  2.0  0.1  34420  2840 pts/0    R+   10:51   0:00 ps aux
root@1ff3c85c7770:/# killall5 1
root@1ff3c85c7770:/# %
```

- Запустил контейнер "docker start reddit"
- Остановил и удалил контейнер "docker stop reddit && docker rm reddit"
- Запустил контейнер без запуска приложения

```bash
docker run --name reddit --rm -it darkarren/otus-reddit:1.0 bash

root@42710bd1a908:/# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  1.2  0.1  18232  3200 pts/0    Ss   10:53   0:00 bash
root        15  0.0  0.1  34420  2908 pts/0    R+   10:53   0:00 ps aux
root@42710bd1a908:/# exit
exit
```

- Получил информацию об образе "docker inspect darkarren/otus-reddit:1.0"
- Получил информацию связанную только с запуском

```bash
docker inspect darkarren/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'

[/bin/sh -c #(nop)  CMD ["/start.sh"]]
```

- Запустил контейнер и внес в него изменения

```bash
docker run --name reddit -d -p 9292:9292 darkarren/otus-reddit:1.0

ecc39f8b4a48cb49de30f174098d23be524fd50690cd1271f77f84e056934e9c

[docker exec -it reddit bash](docker exec -it reddit bash

root@ecc39f8b4a48:/# mkdir /test1234
root@ecc39f8b4a48:/# touch /test1234/testfile
root@ecc39f8b4a48:/# rmdir /opt
root@ecc39f8b4a48:/# exit
exit)
```

- Получил изменения в контейнере

```bash
docker diff reddit
A /test1234
A /test1234/testfile
C /var
C /var/lib
C /var/lib/mongodb
A /var/lib/mongodb/local.0
A /var/lib/mongodb/local.ns
A /var/lib/mongodb/mongod.lock
A /var/lib/mongodb/_tmp
A /var/lib/mongodb/journal
A /var/lib/mongodb/journal/j._0
C /var/log
A /var/log/mongod.log
C /root
A /root/.bash_history
C /tmp
A /tmp/mongodb-27017.sock
D /opt
```

- Остановил, удалил и заново запустил контейнер, убедился, что изменений не сохранилось

```bash
docker stop reddit && docker rm reddit
reddit
reddit

docker run --name reddit --rm -it darkarren/otus-reddit:1.0 bash
root@b7aaf9b04429:/# ls /
bin   dev  home  lib64  mnt  proc    root  sbin  start.sh  tmp  var
boot  etc  lib   media  opt  reddit  run   srv   sys       usr
root@b7aaf9b04429:/#
```

### HW 15: Задание со *

- Подготовлен сценарий terraform, позволяющий развернуть в облаке n машин на чистой ubuntu 16.04, количество машины определяется переменной vm_count="3" в terraform.tfvars
- Подготовлены плейбуки ansible: install.yml  - установка docker и необходимых зависимостей, deploy.yml - запуск прилоежния (reddit.yml - запуск плейбуков друг за другом)
- Подготовлен плейбук для провижининга образа packer - pakcer.yml

</details>

<details>
  <summary>HomeWork 16 - Docker-образы. Микросервисы</summary>

## HomeWork 16 - Docker-образы. Микросервисы

- Установлен линтер hadolint для Dockerfile
- Подключился к docker-host

<details>
  <summary>Подключние к docker-host</summary>

```bash
docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

eval $(docker-machine env docker-host)
```

</details>

- Загрузил архив reddit-microservice и переименовал директорию в src
- Созданы Dockerfile: ./post-py/Dockerfile, ./ui/Dockerfile, ./comment/Dockerfile
- По рекомендации hadolint в ./post-py/Dockerfile инструкция ADD заменена на COPY
- Запущена сборка образа из ./post-py/Dockerfile

<details>
  <summary>Docker build -t darkarren/post:1.0 ./post-py</summary>
  
```bash
Docker build -t darkarren/post:1.0 ./post-py

gcc -Wno-unused-result -Wsign-compare -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -fPIC -I/usr/local/include/python3.6m -c thriftpy/transport/cybase.c -o build/temp.linux-x86_64-3.6/thriftpy/transport/cybase.o
unable to execute 'gcc': No such file or directory
error: command 'gcc' failed with exit status 1
```

</details>

- Так как сборка завершилась с ошибкой - добавлена установка gcc=5.3.0-r0 и musl-dev=1.1.14-r16

<details>
  <summary>Docker build -t darkarren/post:1.0 ./post-py</summary>
  
```bash
Docker build -t darkarren/post:1.0 ./post-py

...
Step 6/7 : ENV POST_DATABASE posts
 ---> Running in 0be207a9aba4
Removing intermediate container 0be207a9aba4
 ---> edce01e1b500
Step 7/7 : CMD ["python3", "post_app.py"]
 ---> Running in 94d476f31848
Removing intermediate container 94d476f31848
 ---> 460a822d35b5
Successfully built 460a822d35b5
Successfully tagged darkarren/post:1.0)
```

</details>

- Файл ./comment/Dockerfile отредактирован в соответствии с замечаниями hadolint
- Запущена сборка docker build -t darkarren/comment:1.0 ./comment

<details>
  <summary>Docker build -t darkarren/comment:1.0 ./comment</summary>
  
```bash
Docker build -t darkarren/comment:1.0 ./comment

...
Step 9/11 : ENV COMMENT_DATABASE_HOST comment_db
 ---> Running in 4ab3b428d36b
Removing intermediate container 4ab3b428d36b
 ---> 4b66c49c7814
Step 10/11 : ENV COMMENT_DATABASE comments
 ---> Running in 8452aaeb171f
Removing intermediate container 8452aaeb171f
 ---> 6997dff60de6
Step 11/11 : CMD ["puma"]
 ---> Running in b187314d9a88
Removing intermediate container b187314d9a88
 ---> f9d0fac5c833
Successfully built f9d0fac5c833
Successfully tagged darkarren/comment:1.0
```

</details>

- Файл ./ui/Dockerfile отредактирован в соответствии с замечаниями hadolint
- Запущена сборка docker build -t darkarren/ui:1.0 ./ui, часть слоев при сборке переимспользована, так как они уже были созданы при сборке comment:1.0

<details>
  <summary>docker build -t darkarren/ui:1.0 ./ui</summary>
  
```bash
docker build -t darkarren/ui:1.0 ./ui

...
Step 11/13 : ENV COMMENT_SERVICE_HOST comment
 ---> Running in 7e09d35e54a2
Removing intermediate container 7e09d35e54a2
 ---> 6c73110a8963
Step 12/13 : ENV COMMENT_SERVICE_PORT 9292
 ---> Running in 6524e87b7977
Removing intermediate container 6524e87b7977
 ---> 0886f17acb2b
Step 13/13 : CMD ["puma"]
 ---> Running in 1126568cc2bc
Removing intermediate container 1126568cc2bc
 ---> 01fc57529a44
Successfully built 01fc57529a44
Successfully tagged darkarren/ui:1.0
```

</details>

- Создана сеть для приложения docker network create reddit
- Запущены контейнеры mongo, comment, ui, post

<details>
  <summary>docker run</summary>
  
```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post darkarren/post:1.0
docker run -d --network=reddit --network-alias=comment darkarren/comment:1.0
docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Проверил доступность и работоспособность приложения по адресу <http://docker-host:9292>

### HW16: Заданиче со * 1

- Остановил все запущенные контейнеры docker kill ${docker ps -q}
- Запустил контейнеры с измененными network-alias и дополнительно переданными значениями переменных

<details>
  <summary>docker images</summary>

```bash
docker run -d --network=reddit --network-alias=post_db_1 --network-alias=comment_db_1 mongo:latest \
&& docker run -d --network=reddit --network-alias=post_1 --env POST_DATABASE_HOST=post_db_1 darkarren/post:1.0 \
&& docker run -d --network=reddit --network-alias=comment_1 --env COMMENT_DATABASE_HOST=comment_db_1 darkarren/comment:1.0 \
&& docker run -d --network=reddit --env POST_SERVICE_HOST=post_1 --env COMMENT_SERVICE_HOST=comment_1 -p 9292:9292 darkarren/ui:1.0
```

</details>

- Проверил доступность и работоспособность приложения по адресу <http://docker-host:9292>

### Образы приложений

- Получил информацию по образам

<details>
  <summary>docker images</summary>
  
```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
darkarren/ui        1.0                 01fc57529a44        About an hour ago   767MB
darkarren/comment   1.0                 f9d0fac5c833        2 hours ago         765MB
darkarren/post      1.0                 be8b9c32ed2b        2 hours ago         198MB
mongo               latest              0da05d84b1fe        2 weeks ago         394MB
ruby                2.2                 6c8e6f9667b2        9 months ago        715MB
python              3.6.0-alpine        cb178ebbf0f2        24 months ago       88.6MB
```

</details>

- Изменил Dockerfile для ui с учетом рекомендаций hadolint

<details>
  <summary>docker build -t darkarren/ui:2.0 ./ui</summary>

```bash
Step 13/13 : CMD ["puma"]
 ---> Running in fdbfcf9fde17
Removing intermediate container fdbfcf9fde17
 ---> bd18fe615ce7
Successfully built bd18fe615ce7
Successfully tagged darkarren/ui:2.0
```

</details>

- Новый образ получился значительно меньше предыдущего

<details>
  <summary>docker images</summary>

```bash
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
darkarren/ui        2.0                 bd18fe615ce7        6 seconds ago       409MB
darkarren/ui        1.0                 01fc57529a44        2 hours ago         767MB
darkarren/comment   1.0                 f9d0fac5c833        2 hours ago         765MB
darkarren/post      1.0                 be8b9c32ed2b        3 hours ago         198MB
mongo               latest              0da05d84b1fe        2 weeks ago         394MB
ubuntu              16.04               7e87e2b3bf7a        4 weeks ago         117MB
ruby                2.2                 6c8e6f9667b2        9 months ago        715MB
python              3.6.0-alpine        cb178ebbf0f2        24 months ago       88.6MB
```

</details>

### HW16: Задание со * 2

- Подготовил новый образ для ui. За счет использования alpine в качестве основного образа, а так же чистки лишних библиотек, которые не нужны после сборки образа, и очистки кэша - удалось уменьшить образ до 38.2MB без потери работоспособности

<details>
  <summary>./ui/Dockerfile</summary>

```dockerfile
FROM alpine:3.9


ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
COPY . $APP_HOME
RUN apk --no-cache add ruby-bundler=1.17.1-r0 ruby-dev=2.5.3-r1 make=4.2.1-r2 gcc=8.2.0-r2 musl-dev=1.1.20-r3 ruby-json=2.5.3-r1 \
  && bundle install --clean --no-cache --force \
  && rm -rf /root/.bundle \
  && apk --no-cache del ruby-dev make gcc musl-dev

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]

```

</details>  

- Подготовил новый образ для post. Удалось уменьшить образ до 106MB

<details>
  <summary>./post-py/Dockerfile</summary>

```Dockerfile
FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app

RUN apk --no-cache add gcc=5.3.0-r0 musl-dev=1.1.14-r16 \
    && pip --no-cache-dir install -r /app/requirements.txt \
    && apk --no-cache del gcc musl-dev

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]
```

</details>

- Подготовил новый образ для comment. Удалось уменьшить до 35.8MB

<details>
  <summary>./comment/Dockerfile</summary>

```Dockerfile
FROM alpine:3.9

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk --no-cache add ruby-bundler=1.17.1-r0 ruby-dev=2.5.3-r1 \
    make=4.2.1-r2 gcc=8.2.0-r2 musl-dev=1.1.20-r3 ruby-json=2.5.3-r1 ruby-bigdecimal=2.5.3-r1 \
    && bundle install --clean --no-cache --force \
    && rm -rf /root/.bundle \
    && apk --no-cache del ruby-dev make gcc musl-dev
COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
```

</details>

- Получившиеся образы в таблице

<details>
  <summary>docker images | grep darkarren | sort</summary>

```bash
docker images | grep darkarren | sort

darkarren/comment   1.0                 f9d0fac5c833        9 hours ago         765MB
darkarren/comment   2.0                 39136f9ffe26        7 minutes ago       35.8MB
darkarren/post      1.0                 be8b9c32ed2b        9 hours ago         198MB
darkarren/post      2.0                 9e4761ed5cc1        2 hours ago         106MB
darkarren/ui        1.0                 01fc57529a44        9 hours ago         767MB
darkarren/ui        2.0                 bd18fe615ce7        7 hours ago         409MB
darkarren/ui        2.1                 40cae6eb63df        6 hours ago         164MB
darkarren/ui        2.2                 40fc6981217f        6 hours ago         62.7MB
darkarren/ui        2.3                 05cfa129177a        5 hours ago         65.8MB
darkarren/ui        2.4                 b7b5e76559ae        5 hours ago         38.2MB
```

</details>

### Docker volume

- Создан docker volume - docker volume create reddit_db
- Контейнеры перезапущены, к mongodb подключен docker volume

<details>
  <summary> docker run </summary>

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest \
&& docker run -d --network=reddit --network-alias=post darkarren/post:2.0 \
&& docker run -d --network=reddit --network-alias=comment darkarren/comment:2.0 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:2.4
e0fd4d9c8dcc65aa77105bdf31c93222af0a8cdeb483f7b315db1284d5aca152
280acbe7c97d4367bf79957b6c83120a3524b810eba0da73d3f0be990713e5b7
7e3325fc0523b7ef2965ab3e7e706a0638897d922b492f0417b0088adc9b7677
f17ce8720c1f5aac24cd65f5513d0ce2d050a3c4988d211de1f64fbcc8c0440a
```
</details>

- Добавлен новый пост, контенеры перезапущены, пост на месте.

</details>

<details>
  <summary>HomeWork 17 - Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов</summary>

## HomeWork 17 - Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

- Работа будет проводиться на docker host (созданный посредством docker-machine), подключение к хосту

<details>
  <summary>docker-host connection</summary>

```bash
docker-machine ls
eval $(docker-machine env docker-host)
```

</details>

### Работа с сетью в Docker

- Загружен образ joffotron/docker-net-tools - `docker pull joffotron/docker-net-tools`
- Контейнер запущен с сетевым драйвером None

<details>
  <summary>docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig</summary>

```bash
docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

```
  
</details>

- Запустил контейнер в сетевом пространстве docker-хоста

<details>
  <summary>docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig</summary>

```bash
docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig

br-090bc9606c2f Link encap:Ethernet  HWaddr 02:42:CE:DE:83:B6
          inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:ceff:fede:83b6%32672/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:2442 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2455 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:285443 (278.7 KiB)  TX bytes:373780 (365.0 KiB)

docker0   Link encap:Ethernet  HWaddr 02:42:8C:E4:9A:22
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:8cff:fee4:9a22%32672/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:38143 errors:0 dropped:0 overruns:0 frame:0
          TX packets:45154 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:3565774 (3.4 MiB)  TX bytes:983075829 (937.5 MiB)

ens4      Link encap:Ethernet  HWaddr 42:01:0A:84:00:0D
          inet addr:10.132.0.13  Bcast:10.132.0.13  Mask:255.255.255.255
          inet6 addr: fe80::4001:aff:fe84:d%32672/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
          RX packets:132075 errors:0 dropped:0 overruns:0 frame:0
          TX packets:119445 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1009726205 (962.9 MiB)  TX bytes:15880944 (15.1 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1%32672/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

</details>

- Выполнен ifconfig напрямую на хосте, результат выполнения одинаковый

<details>
  <summary>docker-machine ssh docker-host ifconfig</summary>

```bash
br-090bc9606c2f Link encap:Ethernet  HWaddr 02:42:ce:de:83:b6
          inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:ceff:fede:83b6/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:2442 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2455 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:285443 (285.4 KB)  TX bytes:373780 (373.7 KB)

docker0   Link encap:Ethernet  HWaddr 02:42:8c:e4:9a:22
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:8cff:fee4:9a22/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:38143 errors:0 dropped:0 overruns:0 frame:0
          TX packets:45154 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:3565774 (3.5 MB)  TX bytes:983075829 (983.0 MB)

ens4      Link encap:Ethernet  HWaddr 42:01:0a:84:00:0d
          inet addr:10.132.0.13  Bcast:10.132.0.13  Mask:255.255.255.255
          inet6 addr: fe80::4001:aff:fe84:d/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
          RX packets:132189 errors:0 dropped:0 overruns:0 frame:0
          TX packets:119547 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1009749599 (1.0 GB)  TX bytes:15896109 (15.8 MB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

</details>

- Запущено четыре контейнера с nginx `docker run --network host -d nginx`
- Выполнение `docker ps` показывает что запущен только один контейнер, так как остальные упали по причине того, что все они используют сеть хоста, и при этом первый из запущенных уже занял порт 80.

<details>
  <summary>docker logs</summary>

```bash
 docker logs 209708b80c20

2019/02/27 12:16:38 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/02/27 12:16:38 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/02/27 12:16:38 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/02/27 12:16:38 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/02/27 12:16:38 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/02/27 12:16:38 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()
```

</details>

- Все запущенные контейнеры остановлены `docker kill $(docker ps -q)`
- На docker-host создан симлинк `sudo ln -s /var/run/docker/netns /var/run/netns`
- После запуска `docker run -d --network host joffotron/docker-net-tools` вывод `sudo ip netns` не изменился
- После запуска `docker run -d --network none joffotron/docker-net-tools` в выводе появился еще один namespace `ce75f7d63d5d`
- Создана bridge-сеть reddit `docker network create reddit --driver bridge`
- Запущены контейнеры reddit с использованием bridge-сети

<details>
  <summary>docker run --network reddit</summary>

```bash
docker run -d --network=reddit mongo:latest \
&& docker run -d --network=reddit darkarren/post:1.0 \
&& docker run -d --network=reddit darkarren/comment:1.0 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Обнаружена проблема с некорректной работой сервисов
- Контейнеры остановлены `docker kill $(docker ps -q)`
- Контейнеры перезапущены с использованием --network-alias

<details>
  <summary>docker run network reddit --network-alias</summary>

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest \
&& docker run -d --network=reddit --network-alias=post darkarren/post:1.0 \
&& docker run -d --network=reddit --network-alias=comment darkarren/comment:1.0 \
&& docker run -d --network=reddit -p 9292:9292 darkarren/ui:1.0
```

</details>

- Результат - приложение работает корректно, контейнеры остановлены `docker kill $(docker ps -q)`
- Созданы новые сети docker-networks

<details>
  <summary>docker network create</summary>

```bash
docker network create back_net --subnet=10.0.2.0/24

docker network create front_net --subnet=10.0.1.0/24
```

</details>

- Контейнеры запущены с использованием новых сетей

<details>
  <summary>docker run</summary>

```bash
docker run -d --network=front_net -p 9292:9292 --name ui darkarren/ui:1.0 \
&& docker run -d --network=back_net --name comment darkarren/comment:1.0 \
&& docker run -d --network=back_net --name post darkarren/post:1.0 \
&& docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
```

</details>

- Обнаружена проблема на главной странице приложения `Can't show blog posts, some problems with the post service. Refresh?`
- Контейнеры подключены к дополнительным сетям `docker network connect front_net post` и `docker network connect front_net comment`
- Теперь приложение работает корректно

### Сетевой стек

- Подключился по ssh к docker-host `docker-machine ssh docker-host`
- Установил пакет bridge-utils `sudo apt-get update && sudo apt-get install bridge-utils`
- Выполнил `sudo docker network ls`

<details>
  <summary>sudo docker network ls</summary>

```bash
sudo docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
9820cacd8fab        back_net            bridge              local
bb82f5fb0c7d        bridge              bridge              local
b03a6069d26e        front_net           bridge              local
0c925de52059        host                host                local
04d056f48418        none                null                local
```

</details>

- Вывел информацию о bridge-сетях `ifconfig | grep br`

<details>
  <summary>ifconfig | grep br && brctl show</summary>

```bash
ifconfig | grep br
br-9820cacd8fab Link encap:Ethernet  HWaddr 02:42:50:cc:73:ca
br-b03a6069d26e Link encap:Ethernet  HWaddr 02:42:c4:f3:68:74

brctl show br-9820cacd8fab
bridge name       bridge id           STP enabled   interfaces
br-9820cacd8fab   8000.024250cc73ca   no            veth33e7906
                                                    veth7716168
                                                    vetheca5e8d

brctl show br-b03a6069d26e
bridge name       bridge id           STP enabled   interfaces
br-b03a6069d26e   8000.0242c4f36874   no            veth12b3738
                                                    vethb898164
                                                    vethdea83a8
```

</details>

- Отобразил iptables `sudo iptables -nL -t nat`
  
<details>
  <summary>sudo iptables -nL -t nat</summary>

```bash
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292
```

</details>

- Нашел процесс, который слушает порт 9292: 

<details>
  <summary>ps ax | grep docker-proxy</summary>

```bash
ps ax | grep docker-proxy
 7319 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
16344 pts/0    S+     0:00 grep --color=auto docker-proxy
```

</details>

### Docker-compose

- Создал файл `./src/docker-compose.yml`
- Остановил контейнеры `docker kill $(docker ps -q)`
- Добавил в env переменную USERNAME `export USERNAME=darkarren`
- Запустил контейнеры через docker-compose `docker-compose up -d`
- Убедился в том, что приложение доступно по <http://docker-host:9292>

### Самостоятельное задание

- Добавлено использование множественных сетей (двух) front_net и back_net вместо использования одной сети reddit, добавил в файл параметры сетей (network range) и алиасы для сервисов
- Порт публикации сервиса ui параметризован и будет задаваться переменной `PUBLIC_PORT`
- Параметризованы версии сервисов, будут использованы переменные `UI_VERSION`, `POST_VERSION` и `COMMENT_VERSION`
- Добавил файл `./src/.env`, указал в нем параметры для запуска контейнеров docker-compose
- Убедился что контейнеры поднимаются и работают корректно
- Выяснил как задается базовое имя проекта при старте контейнеров, очевидно, что по умолчанию берется название папки, в которой находится docker-compose.yml, например в моем случае контенеры (и сети и иже с ними) называются с префиксом `src_`, например: `src_ui_1`. Изменить базовое имя проекта можно следующими способами:
  - указав параметр `COMPOSE_PROJECT_NAME=foo` в переменных окружения
  - указав этот параметр в `.env`, который используется в docker-compose.yml
  - либо указав непосредственно при запуске docker-compose, например: `docker-compose -p foo up -d`

<details>
  <summary>docker-compose -p</summary>

```bash
docker-compose -p avadakedavra up -d
Creating network "avadakedavra_back_net" with the default driver
Creating network "avadakedavra_front_net" with the default driver
Creating volume "avadakedavra_post_db" with default driver
Creating avadakedavra_ui_1      ... done
Creating avadakedavra_post_1    ... done
Creating avadakedavra_post_db_1 ... done
Creating avadakedavra_comment_1 ... done
```

</details>

### Задание со *

- Попробовал подключить директорию `./src` на хост docker-machine, выяснил что для этого необходимо дополнительное по, и при дизмаунте директория остается только на хосте docker-machine, на локальной пропадает. Отказался от этой идеи.
- Скопировал локальную директорию `./src` на хост docker-machine: `docker-machine scp -r -d ./src docker-host:/home/docker-user`
- Создал файл `docker-compose.override.yml`
- Добавил запуск в puma в debug режиме и с двумя воркерами посредством инструкции entrypoint для ui и comment микросервисов

<details>
  <summary>entrypoint</summary>

```bash
   entrypoint:
    - puma
    - --debug
    - -w 2
```

</details>

- Добавил подключение к контейнерам папок с докер-хоста

<details>
  <summary>volumes</summary>

```bash
   volumes:
    - /home/docker-user/src/ui:/app
```

</details>

- Запустил контейнеры `docker-compose up -d`, написал пост, перезапустилконтейнеры и убедился, что пост сохранился

</details>

<details>
  <summary>HomeWork 19 - Устройство Gitlab CI. Построение процесса непрерывной поставки</summary>

## HomeWork 19 - Устройство Gitlab CI. Построение процесса непрерывной поставки

- Создал виртумальную машину через docker-machine

<details>
  <summary>new docker-machine</summary>

```bash
docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-disk-size 100 --google-zone europe-west1-b gitlab-ci
```

</details>

- Подключился к новой vm - `eval $(docker-machine env gitlab-ci)`
- Разрешил подключение к машину через http - https
- Создал необходимые директории и файл docker-compose.yml

<details>
  <summary>gitlab-ci docker-compose</summary>

```bash
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://<YOUR-VM-IP>'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```

</details>

- Установил docker-compose и запустил `docker-compose up -d`
- Установил root-пароль и залогинился в gitlab
- Отключил Sign-up
- Создал Project Group - Homework
- Создал новый проект в группе - example
- Добавил remote в репозиторий DarkArren_microservices `git remote add gitlab http://34.76.49.221/homework/example.git`
- Запушил в gitlab - `git push gitlab gitlab-ci-1`
- Добавил в репозиторий `.gitalb-ci.yml` и запушил в репозиторий
- Получил токен для регистрации раннера `DdPTtWTxaS6o8t9G1LPF`
- Запустил контейнер gitlab-runner на сервере gitlab

<details>
  <summary>gitlab runner</summary>

```bash
docker run -d --name gitlab-runner --restart always \
-v /srv/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```

</details>

- Зарегистрировал gitlab-runner

<details>
  <summary>gitlab-runner registration</summary>

```bash
root@gitlab-ci:/home/docker-user# docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false
Runtime platform                                    arch=amd64 os=linux pid=11 revision=4745a6f3 version=11.8.0
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://34.76.49.221/
Please enter the gitlab-ci token for this runner:
DdPTtWTxaS6o8t9G1LPF
Please enter the gitlab-ci description for this runner:
[730f5101340a]: my-runner
Please enter the gitlab-ci tags for this runner (comma separated):
linux,xenial,ubuntu,docker
Registering runner... succeeded                     runner=DdPTtWTx
Please enter the executor: shell, virtualbox, docker+machine, docker-ssh+machine, docker, docker-ssh, parallels, ssh, kubernetes:
docker
Please enter the default Docker image (e.g. ruby:2.1):
alpine:latest
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

</details>

- Убедился что gitlab-runner доступен в web-интерфейсе
- Убедился что pipeline запустился и прошел успешно
- Добавил в репозиторий исходный код прилоежния reddit и запушил в репозиторий gitlab
- Изменил описание pipeline в .gitlab-ci.yml для запуска тестов приложения
- Добавил файл `simpletest.rb` с описанием теста в директорию приложения
- Добавил библиотеку для тестирования `rack-test` в `reddit/Gemfile`
- Запушил изменения в gitlab и убедился, что тесты прошли

### Окружения

- Изменил deploy_job так, чтобы он стал поределением окржуения dev
- Убедился в том, что в Operations - Environments появилось описание первого окружения - dev
- Добавил в .gitlab-ci.yml описание для окружения stage и production
- Добавил в описание stage и production окружий директиву only, которая позволит запустить job только если установлен semver тэг в git, например, 2.4.10
- Проверил запуск все job при пуше изменений, которые помечены тегом

### Динамические окружения

- Добавил определение динамического окржуения для веток кроме master

### HW19: Задание со * 1

#### Dockerfile

- Подготовил Dockerfile для сборки контейнера с приложением
- Добавил environment variables в Settings проекта (Settings - CI/CD - Environment variables):
   - docker_hub_password - пароль учетной записи для авторизации на docker hub (необходимо для пуша собранного контейнера в registry)
   - добавил в config.toml priveleged = true, добавил "/var/run/docker.sock:/var/run/docker.sock" <https://gitlab.com/gitlab-org/gitlab-runner/issues/1986>

<details>
  <summary>для самопроверки</summary>

```bash
docker network create reddit
docker volume create reddit_db

docker run -d --network=reddit --network-alias=mongo -v reddit_db:/data/db mongo:latest \
&& docker run -d --network=reddit -p 9292:9292 darkarren/reddit:2.0
```

</details>

<details>
  <summary>docker build on gitlab</summary>

```bash
Running with gitlab-runner 11.8.0 (4745a6f3)
  on my-runner q5RBqrdu
Using Docker executor with image docker:dind ...
Pulling docker image docker:dind ...
Using docker image sha256:85e924caedbd3e5245ad95cc7471168e923391b22dcb559decebe4a378a06939 for docker:dind ...
Running on runner-q5RBqrdu-project-1-concurrent-0 via 730f5101340a...
Fetching changes...
HEAD is now at 54100c3 fix syntax error
From http://34.76.49.221/homework/example
   54100c3..4d204b1  gitlab-ci-1 -> origin/gitlab-ci-1
Checking out 4d204b19 as gitlab-ci-1...
Skipping Git submodules setup
$ echo 'Before script'
Before script
$ echo 'Building'
Building
$ docker login -u darkarren -p $docker_hub_password
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
$ docker build -t gitlab-reddit:latest ./reddit
Sending build context to Docker daemon  38.91kB

Step 1/10 : FROM ruby:2.2
 ---> 6c8e6f9667b2
Step 2/10 : RUN apt-get update -qq && apt-get install -y build-essential=11.7 --no-install-recommends  && apt-get clean  && rm -rf /var/lib/apt/lists/*
 ---> Using cache
 ---> bb55fcd3f400
Step 3/10 : ENV APP_HOME /app
 ---> Using cache
 ---> 904eb73308e7
Step 4/10 : RUN mkdir $APP_HOME
 ---> Using cache
 ---> fa49864947db
Step 5/10 : WORKDIR $APP_HOME
 ---> Using cache
 ---> 31566a85676f
Step 6/10 : COPY Gemfile* $APP_HOME/
 ---> Using cache
 ---> 779d7e51e6ff
Step 7/10 : RUN bundle install
 ---> Using cache
 ---> 7898fb071309
Step 8/10 : COPY . $APP_HOME
 ---> Using cache
 ---> d9c9559bbed3
Step 9/10 : ENV DATABASE_URL mongo
 ---> Using cache
 ---> e858759b9ea2
Step 10/10 : CMD ["puma"]
 ---> Using cache
 ---> 579368cc5f66
Successfully built 579368cc5f66
Successfully tagged gitlab-reddit:latest
$ docker tag gitlab-reddit:latest darkarren/otus-reddit:2.0
$ docker push darkarren/otus-reddit:2.0
The push refers to repository [docker.io/darkarren/otus-reddit]
b45ae6f5e9fc: Preparing
2dcaf24f45d8: Preparing
085a3fd2839e: Preparing
b268c71d96a9: Preparing
f1c76ffa42a9: Preparing
80841241fd7e: Preparing
c22d55e31b65: Preparing
9a920ae35b85: Preparing
23044129c2ac: Preparing
8b229ec78121: Preparing
3b65755e1220: Preparing
2c833f307fd8: Preparing
80841241fd7e: Waiting
c22d55e31b65: Waiting
9a920ae35b85: Waiting
23044129c2ac: Waiting
8b229ec78121: Waiting
3b65755e1220: Waiting
2c833f307fd8: Waiting
f1c76ffa42a9: Layer already exists
b268c71d96a9: Layer already exists
085a3fd2839e: Layer already exists
2dcaf24f45d8: Layer already exists
b45ae6f5e9fc: Layer already exists
8b229ec78121: Layer already exists
c22d55e31b65: Layer already exists
80841241fd7e: Layer already exists
23044129c2ac: Layer already exists
9a920ae35b85: Layer already exists
2c833f307fd8: Layer already exists
3b65755e1220: Layer already exists
2.0: digest: sha256:6b72d27ea673c391c08d7da6d7be70f2551cdca95c5125b985df2fd1e8bc43e8 size: 2837
Job succeeded

```

</details>

#### Деплой из Gitlab

- Создал новый service account в gcp, добавил роли Compute Admin и Owner для проекта (скорее всего избыточно и, возможно, небезопасно, однако на борьбу с правами ушло слишком много времени)
- Добавил environment variables в Settings проекта (Settings - CI/CD - Environment variables):
  - gcloud_compute_service_account - учетные данные последующего использования для авторизации в glcoud
  - gcloud_project_id - id проекта docker-123456
  - ssh_key - приватный ключ для авторизации на создаваемых инстансах
- Настроил деплой собранного контейнера на создаваемый инстанс в gcp:
  - Используется docker-образ с предустановленным gcloud sdk
  - gcloud настраивается для работы от имени сервесной учетной записи - на раннер передается json для авторизации под сервисным эккаунтом
  - настраивается ssh - ssh-конфиг, приватный ключ
  - создается инстанс специально для ветки (используется хэш коммита в имени инстанса) `gcloud compute instances create gitlab-reddit-$CI_COMMIT_SHA`
  - посредством ssh command запускаются docker-образы mongodb и приложения, собранного на этапе билда
  - посредством curl делается запрос к главной странице приложения (это минимальная проверка)
  - инстанс удаляется

#### GitLab runner automated deployment

Skipped

#### Интеграция GitLab и Slack

- Добавил в workspace в Slack приложение incoming webhooks
- Получил WebHook URL 
- Добавил webhook url в настройках интеграции со Slack в GitLab (Project Settings - Integration - Slack Notification)
- Убедился что нотификация прошла

</details>

## HomeWork 20 - Введение в мониторинг. Системы мониторинга

- Создано firewall-правило для prometheus `gcloud compute firewall-rules create prometheus-default --allow tcp:9090`
- Создано firewall-правило для puma `gcloud compute firewall-rules create puma-default --allow tcp:9292`
- Создан хост docker-machine 

<details>
  <summary>docker-machine</summary>

```bash
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/
images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone
```

</details>

- Запущен контейнер контейнер prometheus

<details>
  <summary>docker run prometheus</summary>

```bash
docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0

Unable to find image 'prom/prometheus:v2.1.0' locally
v2.1.0: Pulling from prom/prometheus
aab39f0bc16d: Pull complete
a3ed95caeb02: Pull complete
2cd9e239cea6: Pull complete
48afad9e6cdd: Pull complete
8fb7aa0e1c16: Pull complete
3b9d4fd63760: Pull complete
57a87cf4a659: Pull complete
9a31588e38ae: Pull complete
7a0ac0080f04: Pull complete
659e24e6d37f: Pull complete
Digest: sha256:7b987901dbc44d17a88e7bda42dbbbb743c161e3152662959acd9f35aeefb9a3
Status: Downloaded newer image for prom/prometheus:v2.1.0
48249e51e53509a6fec470cbfdfedca54dd8d3c0eb4c2a68cb7b3530bca31f17
```

</details>

- Поосмтрел метрики, которые уже сейчас собирает prometheus
- Посмотрел список таргетов, с которых prometheus забирает метрики
- Остановил контейнер с prometheus `docker stop prometheus`
- Перенес docker-monolith и файлы docker-compose и .env из src в новую директорию docker
- Создал директорию под все, что связано с мониторингом - monitoring
- Добавил monitoring/prometheus/Dockerfile для создания образа с кастомным конфигом
- Создал конфиг prometheus.yml
- Собрал образ prometheus `docker build -t darkarren/prometheus .`
- Собрал образы микросервисов посредсвом docker_build.sh

<details>
  <summary>docker_build.sh</summary>

```bash
for i in ui post-py comment; do cd src/$i; bash
docker_build.sh; cd -; done


```

</details>

- удалил из src/docker-compose.yml директивы build и добавил описание для prometheus
- добавил конфигурацию networks для prometheus в docker-compose
- актуализировал переменные в .env
- запустил контейнеры `docker-compose up -d`
- приложения доступно по адресу <http://34.76.154.234:9292/> и prometheus доступен на <http://34.76.154.234:9090/>

### Мониторинг состояния микросервисов

- Убедился что в prometheus определены и доступны эндпоинты ui и comment
- Получил статус метрики ui_health, так же получил ее в виде графика
- Остановил микросервис post и увидел, что метрика изменила свое значение на 0
- Посмотрел метрики доступности сервисов comment и post
- Заново запустил post-микросервис `docker-compose start post`

### Сбор метрик хоста

- Добавил определение контейнера node-exporter в docker-compose.yml
- Добавил job для node-exporter в конфиг Prometheus и пересобрал контейнер
- Остановил и повторно запустил контейнеры docker-compose
- Убедился в том, что в списке эндпоинтов пояивлся эндпоинт node
- Выполнил `yes > /dev/null` на docker-host и убедился что метрики демонстрируют увеличение нагрузки на процессор
- Загрузил образы на Docker Hub <https://hub.docker.com/u/darkarren>

### HW 20: Задание со * 1

- 
