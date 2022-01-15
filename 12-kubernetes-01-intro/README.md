# Домашнее задание к занятию "12.1 Компоненты Kubernetes"

Вы DevOps инженер в крупной компании с большим парком сервисов. Ваша задача — разворачивать эти продукты в корпоративном кластере.

## Задача 1: Установить Minikube

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.

### Как поставить на AWS:
- создать EC2 виртуальную машину (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type) с типом **t3.small**. Для работы потребуется настроить Security Group для доступа по ssh. Не забудьте указать keypair, он потребуется для подключения.
- подключитесь к серверу по ssh (ssh ubuntu@<ipv4_public_ip> -i <keypair>.pem)
- установите миникуб и докер следующими командами:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    - chmod +x ./kubectl
    - sudo mv ./kubectl /usr/local/bin/kubectl
    - sudo apt-get update && sudo apt-get install docker.io conntrack -y
    - curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
- проверить версию можно командой minikube version
- переключаемся на root и запускаем миникуб: minikube start --vm-driver=none
- после запуска стоит проверить статус: minikube status
- запущенные служебные компоненты можно увидеть командой: kubectl get pods --namespace=kube-system

### Для сброса кластера стоит удалить кластер и создать заново:
- minikube delete
- minikube start --vm-driver=none

Возможно, для повторного запуска потребуется выполнить команду: sudo sysctl fs.protected_regular=0

Инструкция по установке Minikube - [ссылка](https://kubernetes.io/ru/docs/tasks/tools/install-minikube/)

**Важно**: t3.small не входит во free tier, следите за бюджетом аккаунта и удаляйте виртуалку.

```
user@mngr-0:~$ minikube version
minikube version: v1.24.0
commit: 76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b

user@mngr-0:~$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

user@mngr-0:~$ kubectl get pods --namespace=kube-system
NAME                             READY   STATUS    RESTARTS   AGE
coredns-78fcd69978-4hkw9         1/1     Running   0          9m51s
etcd-mngr-0                      1/1     Running   0          10m
kube-apiserver-mngr-0            1/1     Running   0          10m
kube-controller-manager-mngr-0   1/1     Running   0          10m
kube-proxy-m6k2h                 1/1     Running   0          9m51s
kube-scheduler-mngr-0            1/1     Running   0          10m
storage-provisioner              1/1     Running   0          10m
```

## Задача 2: Запуск Hello World
После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

- развернуть через Minikube тестовое приложение по [туториалу](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)
- установить аддоны ingress и dashboard

```
user@mngr-0:~/kube$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created

user@mngr-0:~/kube$ kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           13s

user@mngr-0:~/kube$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-vktxh   1/1     Running   0          30s

user@mngr-0:~/kube$ kubectl get events
LAST SEEN   TYPE     REASON                    OBJECT                             MESSAGE
38s         Normal   Scheduled                 pod/hello-node-7567d9fdc9-vktxh    Successfully assigned default/hello-node-7567d9fdc9-vktxh to mngr-0
38s         Normal   Pulling                   pod/hello-node-7567d9fdc9-vktxh    Pulling image "k8s.gcr.io/echoserver:1.4"
32s         Normal   Pulled                    pod/hello-node-7567d9fdc9-vktxh    Successfully pulled image "k8s.gcr.io/echoserver:1.4" in 5.581972644s
31s         Normal   Created                   pod/hello-node-7567d9fdc9-vktxh    Created container echoserver
31s         Normal   Started                   pod/hello-node-7567d9fdc9-vktxh    Started container echoserver
38s         Normal   SuccessfulCreate          replicaset/hello-node-7567d9fdc9   Created pod: hello-node-7567d9fdc9-vktxh
38s         Normal   ScalingReplicaSet         deployment/hello-node              Scaled up replica set hello-node-7567d9fdc9 to 1
4m34s       Normal   SandboxChanged            pod/main-5dbcd9b67b-hq9ld          Pod sandbox changed, it will be killed and re-created.
4m33s       Normal   Pulled                    pod/main-5dbcd9b67b-hq9ld          Container image "nginx:latest" already present on machine
4m33s       Normal   Created                   pod/main-5dbcd9b67b-hq9ld          Created container main
4m32s       Normal   Started                   pod/main-5dbcd9b67b-hq9ld          Started container main
46s         Normal   Killing                   pod/main-5dbcd9b67b-hq9ld          Stopping container main
4m44s       Normal   Starting                  node/mngr-0                        Starting kubelet.
4m44s       Normal   NodeHasSufficientMemory   node/mngr-0                        Node mngr-0 status is now: NodeHasSufficientMemory
4m44s       Normal   NodeHasNoDiskPressure     node/mngr-0                        Node mngr-0 status is now: NodeHasNoDiskPressure
4m44s       Normal   NodeHasSufficientPID      node/mngr-0                        Node mngr-0 status is now: NodeHasSufficientPID
4m44s       Normal   NodeAllocatableEnforced   node/mngr-0                        Updated Node Allocatable limit across pods
4m33s       Normal   Starting                  node/mngr-0
4m23s       Normal   RegisteredNode            node/mngr-0                        Node mngr-0 event: Registered Node mngr-0 in Controller

user@mngr-0:~/kube$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /root/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 15 Jan 2022 11:56:03 UTC
        provider: minikube.sigs.k8s.io
        version: v1.24.0
      name: cluster_info
    server: https://192.168.0.122:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Sat, 15 Jan 2022 11:56:03 UTC
        provider: minikube.sigs.k8s.io
        version: v1.24.0
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /root/.minikube/profiles/minikube/client.crt
    client-key: /root/.minikube/profiles/minikube/client.key

user@mngr-0:~/kube$ kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed

user@mngr-0:~/kube$ kubectl get services
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.104.180.247   <pending>     8080:31020/TCP   9s
kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          7d2h

user@mngr-0:~/kube$ minikube service hello-node
|-----------|------------|-------------|----------------------------|
| NAMESPACE |    NAME    | TARGET PORT |            URL             |
|-----------|------------|-------------|----------------------------|
| default   | hello-node |        8080 | http://192.168.0.122:31020 |
|-----------|------------|-------------|----------------------------|
* Opening service default/hello-node in default browser...

user@mngr-0:~/kube$ minikube addons enable ingress
  - Using image k8s.gcr.io/ingress-nginx/controller:v1.0.4
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Using image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
* Verifying ingress addon...
* The 'ingress' addon is enabled

user@mngr-0:~/kube$ minikube addons enable dashboard
  - Using image kubernetesui/dashboard:v2.3.1
  - Using image kubernetesui/metrics-scraper:v1.0.7
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server


* The 'dashboard' addon is enabled
```

## Задача 3: Установить kubectl

Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.
- подключиться к minikube
- проверить работу приложения из задания 2, запустив port-forward до кластера

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

Скопировал config, client.key, client.crt, ca.crt

user@home:~/.kube$ kubectl get po
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-7567d9fdc9-vktxh   1/1     Running   0          137m

user@home:~/.kube$ kubectl port-forward hello-node-7567d9fdc9-vktxh 8888:8080

user@home:~/.kube$ curl http://127.0.0.1:8888
CLIENT VALUES:
client_address=127.0.0.1
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://127.0.0.1:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=127.0.0.1:8888
user-agent=curl/7.68.0
BODY:
-no body in request-
```