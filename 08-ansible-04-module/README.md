# Домашнее задание к занятию "08.04 Создание собственных modules"

1. Проверьте module на исполняемость локально.

Поместить файл my_own_collection.py в папку lib/ansible/modules

Создать файл test_module.yml для локального тестирования

```
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "/tmp/mytest",
        "content": "asd"
    }
}
```

Запустим модуль локально
```
python -m ansible.modules.my_own_module test_module.json 

{"changed": true, "path": "/tmp/mytest", "content": "asd", "uid": 1001, "gid": 1001, "owner": "dmytriybessonov", "group": "dmytriybessonov", "mode": "0664", "state": "file", "size": 3, "invocation": {"module_args": {"path": "/tmp/mytest", "content": "asd"}}}
```

2. Напишите single task playbook и используйте module в нём.

Создаем playbook
```
---
- name: test my module
  hosts: localhost
  tasks:
  - name: run module
    my_own_module:
      path: '/tmp/mymodule.txt'
      content: 'test content'
    register: testout
  - name: dump test output
    debug:
      msg: '{{ testout }}'
```

```
ansible-playbook playbook_module.yml 

PLAY [test my module] *********************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [localhost]

TASK [run module] *************************************************************************************************************************************************************
changed: [localhost]

TASK [dump test output] *******************************************************************************************************************************************************
ok: [localhost] => {
    "msg": {
        "changed": true,
        "content": "test content",
        "failed": false,
        "gid": 1001,
        "group": "dmytriybessonov",
        "mode": "0664",
        "owner": "dmytriybessonov",
        "path": "/tmp/mymodule.txt",
        "size": 12,
        "state": "file",
        "uid": 1001
    }
}

PLAY RECAP ********************************************************************************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

ansible-playbook playbook_module.yml 

PLAY [test my module] *********************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [localhost]

TASK [run module] *************************************************************************************************************************************************************
ok: [localhost]

TASK [dump test output] *******************************************************************************************************************************************************
ok: [localhost] => {
    "msg": {
        "changed": false,
        "content": "test content",
        "failed": false,
        "gid": 1001,
        "group": "dmytriybessonov",
        "mode": "0664",
        "owner": "dmytriybessonov",
        "path": "/tmp/mymodule.txt",
        "size": 12,
        "state": "file",
        "uid": 1001
    }
}

PLAY RECAP ********************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

3. Запустите playbook, убедитесь, что он работает.

```
ansible-playbook files/playbook.yml -i files/prod.yml
```