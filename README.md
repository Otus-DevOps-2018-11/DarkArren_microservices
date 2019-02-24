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

## HomeWork 15 - Docker-контейнеры. Docker под капотом

- Создан проект новый проект "docker" в GCE
- GCloud SDK настроен на работу с новым проектом
- Получен файл с аутентификационными данным application_default_credentials.json
- Имя проекта в Gogle Cloud добавленно в env: export GOOGLE_PROJECT=docker
- Создан docker host в GCE

```bash
docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

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
docker run --name reddit --rm -it <your-login>/otus-reddit:1.0 bash

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
