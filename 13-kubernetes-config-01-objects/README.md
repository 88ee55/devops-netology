# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

```
# Deployment фронтенд,бекенд
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: frontend
        image: 88ee55/frontend:v1
        ports:
        - containerPort: 80
      - name: backend
        image: 88ee55/backend:v1
        ports:
        - containerPort: 9000

# StatefulSet базы данных
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mydb
  labels:
    app: mydb
spec:
  selector:
    matchLabels:
      app: mydb
  serviceName: "db"
  replicas: 1
  template:
    metadata:
      labels:
        app: mydb
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: db
        image: postgres:13-alpine
        ports:
        - containerPort: 5432
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news

# Service
---
apiVersion: v1
kind: Service
metadata:
  name: db
  labels:
spec:
  ports:
  - name: postgres
    port: 5432
  selector:
    app: mydb
  type: ClusterIP

# Service
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  ports:
  - name: frontend
    port: 8000
    targetPort: 80
    protocol: TCP
  selector:
    app: myapp
  type: NodePort

kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-86bd88f75c-6qcgf   2/2     Running   0          9m10s
mydb-0                   1/1     Running   0          36s

```

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

```
# Deployment фронтенд
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-frontend
  labels:
    app: myapp-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-frontend
  template:
    metadata:
      labels:
        app: myapp-frontend
    spec:
      containers:
      - name: frontend
        image: 88ee55/frontend:v1
        ports:
        - containerPort: 80
        env:
          - name: BASE_URL
            value: http://myapp-backend:9000

# Deployment бекенд
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-backend
  labels:
    app: myapp-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-backend
  template:
    metadata:
      labels:
        app: myapp-backend
    spec:
      containers:
      - name: backend
        image: 88ee55/backend:v1
        ports:
        - containerPort: 9000
        env:
          - name: DATABASE_URL
            value: postgres://postgres:postgres@db:5432/news

# StatefulSet базы данных
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mydb
  labels:
    app: mydb
spec:
  selector:
    matchLabels:
      app: mydb
  serviceName: "db"
  replicas: 1
  template:
    metadata:
      labels:
        app: mydb
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: db
        image: postgres:13-alpine
        ports:
        - containerPort: 5432
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news

# Service db
---
apiVersion: v1
kind: Service
metadata:
  name: db
spec:
  ports:
  - name: postgres
    port: 5432
  selector:
    app: mydb
  type: ClusterIP

# Service frontend
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  ports:
  - name: frontend
    port: 8000
    targetPort: 80
    protocol: TCP
  selector:
    app: myapp-frontend
  type: NodePort

```

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают.

---