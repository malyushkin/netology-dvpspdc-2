# Практическое задание по теме «Elasticsearch»

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

### Ход работы

Настроим [Docker манифест](docker/docker-compose.yaml), используя [конфигурацию](docker/elasticsearch.yml) Elasticsearch. Запустим `docker-compose`:

```shell
docker-compose up -d --remove-orphans
```

На хостовой машине выполним команду `curl http://localhost:9200` и получим JSON:

```json
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "CNfyojiTSGqoqXuAQ6Xo8w",
  "version" : {
    "number" : "8.2.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "b174af62e8dd9f4ac4d25875e9381ffe2b9282c5",
    "build_date" : "2022-04-20T10:35:10.180408517Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Образ в dockerhub доступен по [ссылке](https://hub.docker.com/r/malyushkin/centos-elasticsearch).

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

### Ход работы

С помощью Elasticsearch API добавим 3 индекса:

```shell
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'
{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-1"}'

curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'
{"settings": {"index": {"number_of_shards": 2, "number_of_replicas": 1}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-2"}'

curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'
{"settings": {"index": {"number_of_shards": 4, "number_of_replicas": 2}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-3"}'
```

Выведем список индексов с помощью команды API `_cat/indices`:

```shell
curl -X GET localhost:9200/_cat/indices/ind-*
yellow open ind-2 k6ifA3ehRcWaVIcmbP8nQg 2 1 0 0 450b 450b
green  open ind-1 KycUyIVUSzCMVpJL7oJFGQ 1 0 0 0 225b 225b
yellow open ind-3 X1GyoX33R5-xRxJRLpPeog 4 2 0 0 900b 900b
```

Состояние кластера с помощью команды API `_cluster/health`:

```shell
curl -X GET localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Удалим все индексы с помощью `DELETE`-запроса: 

```shell
curl -X DELETE localhost:9200/ind-1
curl -X DELETE localhost:9200/ind-2
curl -X DELETE localhost:9200/ind-3
```

Кластер находится в состоянии `yellow`, так как нода одна и есть риск потери данных.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

### Ход работы

Создадим директорию `snapshots`:

```shell
docker exec -it netology_elasticsearch mkdir /elasticsearch-8.2.0/snapshots 
docker exec -it netology_elasticsearch bash -c 'echo "path.repo: /elasticsearch-8.2.0/snapshots" >> /elasticsearch-8.2.0/config/elasticsearch.yml'
docker restart netology_elasticsearch
```

Зарегистрируем директорию как `snapshot repository`:

```shell
curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d '
{"type": "fs", "settings": {"location": "/elasticsearch-8.2.0/snapshots"}}{"acknowledged" : true}'
```

Выведем результат вызова API для репозитория:

```shell
curl -X GET localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.2.0/snapshots"
    }
  }
}
```

Создадим индекс `test` с 0 реплик и 1 шардом:

```shell
curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}{"acknowledged" : true, "shards_acknowledged" : true, "index" : "test"}'

curl -X GET localhost:9200/_cat/indices?v=true
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  V9oqIIgWRL-NzySx7k1M_g   1   0          0            0       225b           225b
```

Создадим snapshot состояния кластера:

```shell
curl -X PUT localhost:9200/_snapshot/netology_backup/snapshot1

docker exec -it netology_elasticsearch ls -la /elasticsearch-8.2.0/snapshots
total 48
drwxr-xr-x 3 elasticsearch elasticsearch  4096 May 17 21:45 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 May 17 21:32 ..
-rw-r--r-- 1 elasticsearch elasticsearch   842 May 17 21:45 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 May 17 21:45 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 May 17 21:45 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18329 May 17 21:45 meta-PUOERVNZQpyjzIZx-41tYQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   354 May 17 21:45 snap-PUOERVNZQpyjzIZx-41tYQ.dat
```

Удалим индекс `test`, создадим индекс `test-2`:

```shell
curl -X DELETE localhost:9200/test
curl -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}{"acknowledged" : true, "shards_acknowledged" : true, "index" : "test-2"}'

curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 M3BHusfXQg--ZsUdYdomRw   1   0          0            0       225b           225b
```

Восстановим состояние кластера из `snapshot` и выведем список индексов:

```shell
curl -X POST localhost:9200/_snapshot/netology_backup/snapshot1/_restore?pretty -H 'Content-Type: application/json' -d '{"indices": "*", "include_global_state": true}{"accepted" : true}'

curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 M3BHusfXQg--ZsUdYdomRw   1   0          0            0       225b           225b
green  open   test   lnMtV1bESfy-Rp7FD0lAgQ   1   0          0            0       225b           225b
```

Видим два индекса: раннее созданный `test-2` и восстановленный `test`.  
