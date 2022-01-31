# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

```
# делайте запросы к бекенду
kubectl port-forward myapp-backend-6cd6dfdcdd-4l89d 9000:80

# сделайте запросы к фронту
kubectl exec myapp-frontend-65bdfb5f6c-dqxqq -- curl 127.1

# подключитесь к базе данных
kubectl port-forward mydb-0 5432:5432
```

## Задание 2: ручное масштабирование
При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. После уменьшите количество копий до 1. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe).

```
kubectl get pod -o wide
NAME                              READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
myapp-backend-6cd6dfdcdd-4l89d    1/1     Running   0          14m   10.233.96.2   node2   <none>           <none>
myapp-frontend-65bdfb5f6c-dqxqq   1/1     Running   0          14m   10.233.92.2   node3   <none>           <none>
mydb-0                            1/1     Running   0          14m   10.233.90.1   node1   <none>           <none>


kubectl scale --replicas=3 deploy/myapp-frontend
deployment.apps/myapp-frontend scaled


# через kubectl describe deploy/y/myapp-frontend не видно на каких нодах добавились копии
kubectl describe deploy myapp-frontend
Name:                   myapp-frontend
Namespace:              default
CreationTimestamp:      Mon, 31 Jan 2022 21:41:52 +0500
Labels:                 app=myapp-frontend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=myapp-frontend
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=myapp-frontend
  Containers:
   frontend:
    Image:      88ee55/frontend:v1
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BASE_URL:  http://myapp-backend:9000
    Mounts:      <none>
  Volumes:       <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   myapp-frontend-65bdfb5f6c (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  20m    deployment-controller  Scaled up replica set myapp-frontend-65bdfb5f6c to 1
  Normal  ScalingReplicaSet  2m33s  deployment-controller  Scaled up replica set myapp-frontend-65bdfb5f6c to 3


kubectl get pod -o wide
NAME                              READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
myapp-backend-6cd6dfdcdd-4l89d    1/1     Running   0          18m   10.233.96.2    node2   <none>           <none>
myapp-frontend-65bdfb5f6c-555vw   1/1     Running   0          67s   10.233.105.2   node4   <none>           <none>
myapp-frontend-65bdfb5f6c-dqxqq   1/1     Running   0          18m   10.233.92.2    node3   <none>           <none>
myapp-frontend-65bdfb5f6c-h8wwt   1/1     Running   0          67s   10.233.96.3    node2   <none>           <none>
mydb-0                            1/1     Running   0          18m   10.233.90.1    node1   <none>           <none>


kubectl scale --replicas=3 deploy/myapp-backend
deployment.apps/myapp-backend scaled


kubectl get pod -o wide
NAME                              READY   STATUS    RESTARTS   AGE     IP             NODE    NOMINATED NODE   READINESS GATES
myapp-backend-6cd6dfdcdd-4l89d    1/1     Running   0          26m     10.233.96.2    node2   <none>           <none>
myapp-backend-6cd6dfdcdd-jj565    1/1     Running   0          4m59s   10.233.92.3    node3   <none>           <none>
myapp-backend-6cd6dfdcdd-tjk6n    1/1     Running   0          4m59s   10.233.90.2    node1   <none>           <none>
myapp-frontend-65bdfb5f6c-555vw   1/1     Running   0          8m45s   10.233.105.2   node4   <none>           <none>
myapp-frontend-65bdfb5f6c-dqxqq   1/1     Running   0          26m     10.233.92.2    node3   <none>           <none>
myapp-frontend-65bdfb5f6c-h8wwt   1/1     Running   0          8m45s   10.233.96.3    node2   <none>           <none>
mydb-0                            1/1     Running   0          26m     10.233.90.1    node1   <none>           <none>


kubectl scale --replicas=1 deploy/myapp-backend
deployment.apps/myapp-backend scaled
kubectl scale --replicas=1 deploy/myapp-frontend
deployment.apps/myapp-frontend scaled


kubectl get pod -o wide
NAME                              READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
myapp-backend-6cd6dfdcdd-4l89d    1/1     Running   0          27m   10.233.96.2   node2   <none>           <none>
myapp-frontend-65bdfb5f6c-dqxqq   1/1     Running   0          27m   10.233.92.2   node3   <none>           <none>
mydb-0                            1/1     Running   0          27m   10.233.90.1   node1   <none>           <none>
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---