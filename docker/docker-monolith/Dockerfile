# будет использован образ ubuntu версии 16.04
FROM ubuntu:16.04
# обновляем кэш репозитория и устанавливаем необходимые пакеты
RUN apt-get update
RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
RUN gem install bundler
# скачиваем приложение из репозитория на сервер
RUN git clone -b monolith https://github.com/express42/reddit.git
# загружаем на сервер конфигурационные файлы
# конфиг для MongoDB
COPY mongod.conf /etc/mongod.conf
# конфиг для запуска puma - куда стучаться за базой данных
COPY db_config /reddit/db_config
# скрипт запуска
COPY start.sh /start.sh
# устанавливаем зависимости приложения и запускаем его
RUN cd /reddit && bundle install
RUN chmod 0777 /start.sh
# приложение будет стартовать при старте контейнера
CMD ["/start.sh"]



