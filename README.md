# README

## Задача

> Используя фреймворк Ruby on Rails 5 разработайте приложение, которое с определенной периодичностью собирает новости из RSS-ленты (прим. https://lenta.ru/rss/news) и сохраняет в локальную БД postresql. Задачу сбора и сохранения реализовать в виде rake-task. Вторая часть приложения - API, реализующий метод получения новостей и метод полнотекстового поиска. Метод получения новостей должен поддерживать возможность передать limit и offset. Метод полнотекстового поиска по заголовку и содержимому должен быть реализован стандартными средствами postgresql. API должен быть версионирован с v0.
> Будет плюсом покрытие методов API тестами (rspec).

## Развертывание

Для пользователей docker-machine:

```bash
docker-machine create --driver virtualbox lenta-rss-scraper
docker-machine stop lenta-rss-scraper
VBoxManage modifyvm lenta-rss-scraper --natpf1 "rails,tcp,127.0.0.1,3000,,3000"
VBoxManage modifyvm lenta-rss-scraper --natpf1 "postgres,tcp,127.0.0.1,5434,,5434"
docker-machine start lenta-rss-scraper
eval $(docker-machine env lenta-rss-scraper)

docker-compose up
```

Для остальных:

```
docker-compose up
```

*Если первый запуск выдаст ошибку `lentarssscraper_api_1 exited with code 1`, нужно запустить еще раз*

## Интерфейс

Запуск рейк-таска на получение фида: 

```
docker-compose exec api rake rss_feeds:grub
```

Прохождение тестов:

```
docker-compose exec api bundle exec rspec
```

API:

```
curl "localhost:3000/api/v0/rss_feeds.json?page=1&per=10"
curl "localhost:3000/api/v0/rss_feeds/search?q=...&page=1&per=10"
```

## Реализация

За получение и сохранение rss-записей отвечает таск rss_feeds:grub. Его можно вызвать в качестве воркера или демонизировать. Таск пишет в лог `log/rss_feeds-grub.log`.

```
# Если передать frequency, то будет работать с соответствующим интервалом, 
# игнорируя возможные исключения.
# Если вызвать с demonize, то процесс будет демонизирован.
# Без аргументов таск просто отработает (удобно ставить в крон).
rake rss_feeds:grub[5.minutes,false]
```

Для AR-методов поиска использован гем `textacular`.

Вместо параметров limit и offset сделана пагинация.

Для сериализации json-ответов использован active_model_serializers. В ответ добавлена мета-информация о пагинации.

Написаны тесты для модели, контроллера и рейк-таска, при этом удаленные вызовы записаны как vcr-кассета.

При вызове `rails db:seed` первый раз, заполняется таблица rss_feeds (из vcr-кассеты).

При запуске приложения через docker-compose вызывается `db:create db:migrate db:seed`, поэтому приложение готово к работе, без прединициализации. Можно поднять приложение не целиком, а только СУБД - `docker-compose up db`.
