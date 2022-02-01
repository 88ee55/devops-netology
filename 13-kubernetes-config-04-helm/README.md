# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

```
[helm](netology)
```

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

```
helm install --set namespace=app1 myapp netology
NAME: myapp
LAST DEPLOYED: Tue Feb  1 18:45:24 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

helm upgrade --set namespace=app1,image.tag=v2 myapp netology
Release "myapp" has been upgraded. Happy Helming!
NAME: myapp
LAST DEPLOYED: Tue Feb  1 18:46:55 2022
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None


helm install --set namespace=app2,image.tag=v3 myapp netology
Error: INSTALLATION FAILED: cannot re-use a name that is still in use

helm install --set namespace=app2,image.tag=v3 myappv3 netology
NAME: myappv3
LAST DEPLOYED: Tue Feb  1 18:56:33 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

```

## Задание 3 (*): повторить упаковку на jsonnet
Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.

```

```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---