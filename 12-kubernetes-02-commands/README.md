# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

```
user@mngr-0:~$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node created

user@mngr-0:~$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           7s

user@mngr-0:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-82w5c   1/1     Running   0          13s
hello-node-7567d9fdc9-pvn8z   1/1     Running   0          13s
```

## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

```
user@mngr-0:~$ kubectl create namespace app-namespace
namespace/app-namespace created

user@mngr-0:~$ kubectl config set-context --current --namespace=app-namespace
Context "minikube" modified.

user@mngr-0:~$ kubectl create serviceaccount dev
serviceaccount/dev created

user@mngr-0:~$ kubectl create role dev_read --verb=get --verb=list --verb=watch --resource=pods
role.rbac.authorization.k8s.io/dev_read created

user@mngr-0:~$ kubectl create rolebinding dev_read --serviceaccount=app-namespace:dev --role=dev_read
rolebinding.rbac.authorization.k8s.io/dev_read created

user@mngr-0:~$ TOKEN=$(kubectl get secrets $(kubectl get serviceaccount dev -o json | jq -r .secrets[0].name) -o json | jq -r .data.token | base64 -d)

user@mngr-0:~$ kubectl config set-credentials dev_user --token=$TOKEN
User "dev_user" set.

user@mngr-0:~$ kubectl config set-context dev --user=dev_user --cluster minikube --namespace app-namespace
Context "dev" created.

user@mngr-0:~$ kubectl config use-context dev
Switched to context "dev".
```

## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

```

```
user@mngr-0:~$ kubectl scale --replicas=5 deployment/hello-node
deployment.apps/hello-node scaled

user@mngr-0:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-7hxr7   1/1     Running   0          21s
hello-node-7567d9fdc9-82w5c   1/1     Running   0          3h42m
hello-node-7567d9fdc9-ldl7z   1/1     Running   0          21s
hello-node-7567d9fdc9-pvn8z   1/1     Running   0          3h42m
hello-node-7567d9fdc9-wpjzw   1/1     Running   0          21s
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---