# Домашнее задание к занятию "08.02 Работа с Playbook"

Playbook предназначен для установки x64 версий на Linux
- jdk
- elasticsearch
- kibana

В директории files/ должен находиться архив с jdk

Дополнительные переменные можно указать в шаблонах

Переменные для указания версии:
- java_jdk_version
- elastic_version
- kibana_version

Переменные для указания пути установки:
- elastic_home
- kibana_home

Поддерживаемые теги:
 - java
 - elastic
 - kibana

Поднять контейнер с именем ubuntu

```docker run -d --name=ubuntu -p 9200:9200 -p 5601:5601 ubuntu:my sleep 60000```

Запустить playbook

```ansible-playbook -i inventory/prod.yml site.yml```

Зайти в контейнер, запустить elasticsearch и kibana
```
docker exec -it ubuntu bash
elasticsearch -d -p pid && kibana
```