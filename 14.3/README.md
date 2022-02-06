# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created

kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
NAME               DATA   AGE
domain             1      19s
kube-root-ca.crt   1      95m
nginx-config       1      43s


kubectl get configmap
NAME               DATA   AGE
domain             1      38s
kube-root-ca.crt   1      95m
nginx-config       1      62s
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      103s


kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: vault-nginx-template
    data:
      nginx.conf.tmpl: |
        worker_processes     4;
        worker_rlimit_nofile 65535;
        pid /tmp/nginx.pid;


        events {
            multi_accept       on;
            worker_connections 65535;
        }

        http {
            charset                utf-8;
            sendfile               on;
            tcp_nopush             on;
            tcp_nodelay            on;
            server_tokens          off;
            log_not_found          off;
            types_hash_max_size    2048;
            types_hash_bucket_size 64;
            client_max_body_size   16M;


            # Logging
            access_log             /var/log/nginx/access.log;
            error_log              /var/log/nginx/error.log warn;

            server {
                listen 8080;
                client_body_temp_path /tmp/client_temp;
                proxy_temp_path /tmp/proxy_temp;
                fastcgi_temp_path /tmp/fastcgi_temp;
                uwsgi_temp_path /tmp/uwsgi_temp;
                scgi_temp_path /tmp/scgi_temp;

                location / {
                  {{ with secret "secrets/k11s/demo/app/nginx" }}
                  return 200 '{{ .Data.data.responseText }}';
                  add_header Content-Type text/plain always;
                  {{ end }}
                }
                }
        }
    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: vault-agent-configs
    data:
      vault-agent-init.hcl: |
        pid_file = "/tmp/.pidfile"

        auto_auth {
          mount_path = "auth/approle"
          method "approle" {
            config = {
              role_id_file_path = "/etc/vault/config/app-role-id"
            }
          }
        }
        template {
                    source      = "/etc/vault/config/template/nginx/nginx.conf.tmpl"
                    destination = "/etc/vault/config/render/nginx/nginx.conf"
        }

        vault {
          address = "http://vault:8200"
        }
        exit_after_auth = true
      vault-agent-reload.hcl: |
        pid_file = "/tmp/.pidfile"

        auto_auth {
          mount_path = "auth/approle"
          method "approle" {
            config = {
              role_id_file_path = "/etc/vault/config/app-role-id"
            }
          }
        }

        template {
              source      = "/etc/vault/config/template/nginx/nginx.conf.tmpl"
              destination = "/etc/vault/config/render/nginx/nginx.conf"
              command = "ps ax | grep 'nginx: maste[r]' | awk '{print $1}' | xargs kill -s HUP"
        }
        template_config {
              static_secret_render_interval = "1m"
        }

        vault {
          address = "http://vault:8200"
        }

      app-role-id: |
        c4b1e046-826e-232f-01c8-a2e700471b56
kind: ConfigMap
metadata:
  creationTimestamp: "2022-02-06T13:32:23Z"
  name: nginx-config
  namespace: default
  resourceVersion: "12425"
  uid: a91f1160-b703-4242-bf00-2c52a8afe07b


kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-02-06T13:32:47Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "12477",
        "uid": "6838f44c-ae0d-440b-82ca-087cdbf3e5a6"
    }
}
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml

ls
nginx.conf  nginx-config.yml
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
configmap/nginx-config created
```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, configmaps) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---