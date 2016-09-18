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

## Интерфейс

Запуск рейк-таска на получение фида: `docker-compose exec api rake import:lenta_feed`

```
curl "localhost:3000/api/v0/feeds.json?page=1&per=10"
curl "localhost:3000/api/v0/feeds/search?q=...page=..."
```
