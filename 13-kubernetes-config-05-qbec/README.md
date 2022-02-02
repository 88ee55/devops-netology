# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

[qbec](netology)

```
qbec apply stage
kubectl -n stage get po
NAME                        READY   STATUS    RESTARTS   AGE
rabbitmq-7c85dfd9bc-86p5v   1/1     Running   0          34s


qbec apply production
kubectl -n production get po,service,endpoints
NAME                            READY   STATUS    RESTARTS   AGE
pod/rabbitmq-7c85dfd9bc-gjw27   1/1     Running   0          34s
pod/rabbitmq-7c85dfd9bc-nkrkn   1/1     Running   0          34s
pod/rabbitmq-7c85dfd9bc-sv8nt   1/1     Running   0          34s

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/rabbitmq   ClusterIP   10.233.21.248   <none>        5672/TCP   33s

NAME                 ENDPOINTS                                             AGE
endpoints/rabbitmq   10.233.105.3:5672,10.233.92.2:5672,10.233.96.2:5672   33s
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---