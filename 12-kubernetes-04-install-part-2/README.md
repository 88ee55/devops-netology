# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

```
# Установим git и pip
sudo apt install git python3-pip
# Склонируем репо
git clone https://github.com/kubernetes-sigs/kubespray && cd kubespray
# Установим зависимости
sudo pip3 install -r requirements.txt
# Скопируем шаблон
cp -rfp inventory/sample inventory/mycluster
# Обновим inventory
declare -a IPS=(master1,10.130.0.9 10.130.0.6 10.130.0.26 10.130.0.24 10.130.0.28)
CONFIG_FILE=inventory/mycluster/hosts.yaml KUBE_CONTROL_HOSTS=1 python3 contrib/inventory_builder/inventory.py ${IPS[@]}
# В inventory/mycluster/hosts.yaml в разделе etcd оставим только master1
# Изменим CRI на containerd
# В шаблоне уже установлен (изменили в конце 2021 года)
# Развернем кластер
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v
```
[hosts.yaml](hosts.yaml)


## Задание 2 (*): подготовить и проверить инвентарь для кластера в AWS
Часть новых проектов хотят запускать на мощностях AWS. Требования похожи:
* разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
* работать должны на минимально допустимых EC2 — t3.small.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---