# Домашнее задание к занятию "13.2 разделы и монтирование"
Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные. А сам бекенд генерирует статику для фронта. Нужно оптимизировать это.
Для настройки NFS сервера можно воспользоваться следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до kubectl):
* установить helm: curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
* добавить репозиторий чартов: helm repo add stable https://charts.helm.sh/stable && helm repo update
* установить nfs-server через helm: helm install nfs-server stable/nfs-server-provisioner

В конце установки будет выдан пример создания PVC для этого сервера.

## Задание 1: подключить для тестового конфига общую папку
В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:
* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

```
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
        env:
          - name: BASE_URL
            value: http://myapp-backend:9000
        volumeMounts:
          - mountPath: "/static"
            name: my-volume
      - name: backend
        image: 88ee55/backend:v1
        ports:
        - containerPort: 9000
        env:
          - name: DATABASE_URL
            value: postgres://postgres:postgres@db:5432/news
        volumeMounts:
          - mountPath: "/static"
            name: my-volume
      volumes:
        - name: my-volume
          emptyDir: {}
```

## Задание 2: подключить общую папку для прода
Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

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
        volumeMounts:
          - mountPath: "/data/pv"
            name: my-volume
    volumes:
      - name: my-volume
        persistentVolumeClaim:
          claimName: pvc

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
        volumeMounts:
          - mountPath: "/data/pv"
            name: my-volume
    volumes:
      - name: my-volume
        persistentVolumeClaim:
          claimName: pvc

# PVC
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
spec:
  storageClassName: nfs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

NAME                                      READY   STATUS    RESTARTS   AGE
pod/myapp-backend-6486d8fbd6-mhj7g        1/1     Running   0          95s
pod/myapp-frontend-7c5744c657-fhw8l       1/1     Running   0          5m10s
pod/nfs-server-nfs-server-provisioner-0   1/1     Running   0          3h20m

NAME                        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc   Bound    pvc-9fb5677d-b12a-48db-bd43-2c69bc62ecd9   1Gi        RWX            nfs            10m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
persistentvolume/pvc-9fb5677d-b12a-48db-bd43-2c69bc62ecd9   1Gi        RWX            Delete           Bound    default/pvc   nfs                     10m
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---