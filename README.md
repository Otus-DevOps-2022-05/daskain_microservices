# daskain_microservices
daskain microservices repository

# Выполнено ДЗ №15

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Разбирался как сети работают в Докере
 - Разобрался с docker-compose
 - Разобраться с параметризацией docker-compose

### Запуск nginx
Мы используем одну сеть с одним набором портов. Т.к. мы запускаем экземпляры NGINX на одном и том же порту, то рабочим будет только последний контейнер


### Параметры docker-compose
Судя по доке, имя проекта береться от имени папки, в которой лежит файл docker-compose. Его можно переопределить задав через флаг -p при запуске docker-compose:
```
docker-compose -p project_name up -d
```

Второй способ - использовать файл с параметрами .env. В него можно добавить все параметры, которые мы сможем параметризировать при создании файла.

## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №16

 - [x] Основное ДЗ
 - [x] Задание со * Автоматизация развёртывания GitLab (по желанию)
 - [x] Задание со * Регистрация ранера через Ansible
 - [х] Задание со * Запуск reddit в контейнере
 - [ ] Задание со * Настройка оповещений в Slack

## В процессе сделано:
 - Развернул инстанс для Gitlab
 - При помощи Ansible  развернул на хосте gitlab
 - Запушил infra репозиторий в Gitlab

### Инстанс для gitlab
Создал инстанс через yc-cli:
```
yc compute instance create   --name gitlab-ci-vm   --memory=8   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50   --ssh-key ./id_rsa.pub
```

### Gitlab и Ansible

Развернул инстанс при помощи Ansible playbook. На первом этапе подготовил хост (установил doker + окружение для него). На втором этапе, через шаблон, создал compose файл для запуска Gitlab.

Пароль для рута генериться при запуске контейнера, его можн найти в файле сонфигурации на хосте:
```
daskain@gitlab-ci-vm:/srv/gitlab/config$ sudo cat /srv/gitlab/config/initial_root_password
```

### Пайплайны
Создал пайплайн для инфра репозитория. Зарегистрировал раннер вручную. Создал Ansible плэйбук для регистрации ранеров.

Тесты не запустились, коллеги посоветовали добавить памяти в инстанс

### Запуск контейнера с reddit
Добавил в пайплайн, в build добавил использование ранее созданого docker образа



## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №17

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Переделал структуру репозитория
 - Равзернул мониторинг через прометей
 - Запушил образы в докер хаб

### Переделал структуру репозитория
Переделал структуру репозитория, перенес в папку docker папку docker-monolith. Создал папку monitoring

### Равзернул мониторинг через прометей
Используя докер, развернул инстасн прометея

### Запушил образы в докер хаб
Образы запушил в докер - https://hub.docker.com/u/daskain

## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания

# Выполнено ДЗ №18

 - [x] Основное ДЗ
 - [ ] Задание со *

## В процессе сделано:
 - Подготовка окружения
 - Логирование Docker-контейнеров
 - Сбор неструктурированных логов
 - Визуализация логов
 - Сбор структурированных логов
 - Распределенный трейсинг

### Окружение
Установил необходимые компоненты на ПК, пересобрал Docker-образы и запушил в свое репо
Создал и запустил хост с докером

### Структурированные логи
Настроил сбор логов для сервиса post. Index настроил на паттерн fluentd. Далее разбил логи на несколько полей через конфигу.

### Неструктурированные логи
Настроил сбор логов для сервиса ui. Далее разбил логи на несколько полей через конфигу.
Включил zipkin


## Как проверить
Создать хост:
```
 yc compute instance create \
  --name logging \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --memory=6 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ./id_rsa.pub
```

Запустить докер:
```
  docker-machine create \
  --driver generic \
  --generic-ip-address=<YANDEX_IP> \
  --generic-ssh-user yc-user \
  --generic-ssh-key ./id_rsa \
 logging
```

Сервис доступен по адресу:
```
http://YANDEX_IP:9292/
```

Кибана доступна по адресу:
```
http://YANDEX_IP:5601/
```


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания

# Выполнено ДЗ №19

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:
 - Подготовил репо
 - Развернул кластер k8s в облаке
 - Развернул кластер через ansible и terraform


 ### Подготовка
 Создал папки в репо для ДЗ, добавил файлы манифестов


### Кластер кубера
Подготовил шаблон терраформа для мастер и воркер нод. В примере запустил 1 мастер, 2 воркер ноды. Через плэйбуки раскатал и подружил их между собой

Инвентори не динамическое, приходится руками править. Пока не знаю как сделать динамически.
Конфиги подгружается на локальную машину.

## Как проверить
Создать инстансы (3 штуки на данный момент):
```
terraform apply
```

Скопировать ip в inventory, запустить пайплайны.
Мастер:
```
ansible-playbook k8s_master.yml
```
Воркер:
```
ansible-playbook k8s_worker.yml
```

Скопировать конфигу на локуальную машину

Проверить ноды:
```
$kubectl get node
NAME    STATUS   ROLES           AGE     VERSION
k8s-0   Ready    control-plane   15m     v1.25.3
k8s-1   Ready    <none>          7m48s   v1.25.3
k8s-2   Ready    <none>          7m48s   v1.25.3
```
Создать поды:
```
$kubectl apply -f mongo-deployment.yml
$kubectl apply -f post-deployment.yml
$kubectl apply -f ui-deployment.yml
$kubectl apply -f comment-deployment.yml
```
Проверить поды:
```
$kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
comment-deployment-745b4cdb5f-4kvwq   1/1     Running   0          6m22s
mongo-deployment-759bbff9f9-x8llk     1/1     Running   0          6m13s
post-deployment-989d6d77c-pxc8k       1/1     Running   0          6m4s
ui-deployment-67ff9b5d5-lc6ns         1/1     Running   0          6m1s
```


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №20

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:
 - Развернуть minikube
 - Развернуть приложение в minikube
 - Создал кластер в облаке
 - Развернул на кластере в облаке приложение
 - Задание со * - развернуть дашбоард

### Раверзнуть minikube
Скачал и установил. Запустил:
```
$kubectl get nodes
NAME       STATUS   ROLES    AGE     VERSION
minikube   Ready    master   2m56s   v1.19.7
```
### Развернуть приложение в minikube
Запустил UI-компонент:
```
$kubectl get pods --selector component=ui
NAME                  READY   STATUS    RESTARTS   AGE
ui-86b84cdf4f-7cbvd   1/1     Running   0          103s
ui-86b84cdf4f-c4bt6   1/1     Running   0          103s
ui-86b84cdf4f-r24gn   1/1     Running   0          103s
```
Сконфигурировал и запустил остальные комопненты приложения

### Развернул кластер кубера в облаке
Кластер кубера:
```
$kubectl config get-contexts
CURRENT   NAME                          CLUSTER                               AUTHINFO                              NAMESPACE
          kubernetes-admin@kubernetes   kubernetes                            kubernetes-admin
          minikube                      minikube                              minikube                              default
*         yc-k8s                        yc-managed-k8s-cat2jdvpqihaedc23i3p   yc-managed-k8s-cat2jdvpqihaedc23i3p
$kubectl config current-context
yc-k8s
$kubectl get nodes -o wide
NAME                        STATUS   ROLES    AGE   VERSION    INTERNAL-IP   EXTERNAL-IP       OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
cl16rqf4j7thsn0vl016-eveq   Ready    <none>   25m   v1.20.11   10.128.0.5    178.154.207.84    Ubuntu 20.04.4 LTS   5.4.0-124-generic   docker://20.10.17
cl16rqf4j7thsn0vl016-ymyv   Ready    <none>   25m   v1.20.11   10.128.0.25   178.154.202.100   Ubuntu 20.04.4 LTS   5.4.0-124-generic   docker://20.10.17
```
### Развернул приложение
Поды:
```
$kubectl get pods -o wide -n dev
NAME                       READY   STATUS    RESTARTS   AGE     IP              NODE                        NOMINATED NODE   READINESS GATES
comment-5dc6d868b6-zr6nf   1/1     Running   0          4m14s   10.112.129.9    cl16rqf4j7thsn0vl016-eveq   <none>           <none>
mongo-77dbd4f49f-fhbzb     1/1     Running   0          4m14s   10.112.128.10   cl16rqf4j7thsn0vl016-ymyv   <none>           <none>
post-7bf59855cf-6rzhc      1/1     Running   0          4m9s    10.112.129.11   cl16rqf4j7thsn0vl016-eveq   <none>           <none>
post-7bf59855cf-cbrj7      1/1     Running   0          4m14s   10.112.128.12   cl16rqf4j7thsn0vl016-ymyv   <none>           <none>
post-7bf59855cf-g4q2q      1/1     Running   0          4m6s    10.112.128.13   cl16rqf4j7thsn0vl016-ymyv   <none>           <none>
ui-5d769db5bb-8nm2k        1/1     Running   0          4m8s    10.112.129.12   cl16rqf4j7thsn0vl016-eveq   <none>           <none>
ui-5d769db5bb-pzpd2        1/1     Running   0          4m11s   10.112.129.10   cl16rqf4j7thsn0vl016-eveq   <none>           <none>
ui-5d769db5bb-vcjrm        1/1     Running   0          4m14s   10.112.128.11   cl16rqf4j7thsn0vl016-ymyv   <none>           <none>
$kubectl describe service ui -n dev | grep NodePort
Type:                     NodePort
NodePort:                 <unset>  31917/TCP
```

## Задание со * - развернуть дашбоард
Установить дашборд:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
```
Создать пользователя:
```
kubectl --namespace kubernetes-dashboard create serviceaccount kuber
```
Задать роль:
```
kubectl apply -f kubernetes-dashboard
```
Получить токен:
```
kubectl -n kubernetes-dashboard create token kuber
```

Интерфейс доступен по адресу:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default



## Как проверить
Развернуть в кластере и проверить по адресу node_ip:port
Microservices Reddit in dev ui-5d769db5bb-vcjrm container
Дашборд доступен по адресу:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания


# Выполнено ДЗ №21

 - [x] Основное ДЗ
 - [x] Задание со * добавить манифест для создания Secret


## В процессе сделано:
 - Развернуть кластер k8s и приложение
 - Изменить тип сервиса на LoadBalancer
 - Запустить ingress-nginx
 - Добавить TLS
 - Создал манифест для Secret
 - NetworkPolicy

### Подготовка
Создал инстанс и задеплоил приложение
Добавил LoadBalancer и ingress-nginx
Добавил TLS

### Задание со * добавить манифест для создания Secret
Создал манифест ui-secret.yml. В base64 закодировал ключ и серт
```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.190.66.90"
$cat tls.key | base64
$cat tls.crt | base64
$kubectl create -f ui-secret.yml -n dev
$kubectl get secret -n dev
NAME                  TYPE                                  DATA   AGE
default-token-6qpfl   kubernetes.io/service-account-token   3      82m
ui-ingress            kubernetes.io/tls                     2      3s
$ kubectl describe secret ui-ingress -n dev
Name:         ui-ingress
Namespace:    dev
Labels:       app=reddit
              component=ui
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1123 bytes
tls.key:  1708 bytes
```

### NetworkPolicy
NetworkPolicy через calico доступен. Добавил манифест mongo-newtwork-policy.yml. В нем добавил блоки для разрешения доступа

### Внешний volume для mongo
Создал диск:
```
$yc compute disk create --name k8s --size 4 --description "disk for k8s" --zone ru-central1-a --folder-id b1gredog3lnp4c6m5gdr

$yc compute disk list --folder-id b1gredog3lnp4c6m5gdr
+----------------------+------+-------------+---------------+--------+----------------------+--------------+
|          ID          | NAME |    SIZE     |     ZONE      | STATUS |     INSTANCE IDS     | DESCRIPTION  |
+----------------------+------+-------------+---------------+--------+----------------------+--------------+
| fhmh2bdet4e0p1a49btq |      | 68719476736 | ru-central1-a | READY  | fhmn2jrkvi0f2cckh13a |              |
| fhmrgls9spuhh7k68kp2 |      | 68719476736 | ru-central1-a | READY  | fhm7fhjifldf56t81d9o |              |
| fhmvq13bqh91d4rq47p4 | k8s  |  4294967296 | ru-central1-a | READY  |                      | disk for k8s |
+----------------------+------+-------------+---------------+--------+----------------------+--------------+
```

Создал манифесты для mongo-pv и mongo-pvc. Изменил манифест для деплоя mongo и пересоздал.

После всех манипуляций добавил посты, пересоздал деплоймент - посты на месте


## Как проверить

```
$terraform apply
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

cluster_external_v4_endpoint = https://178.154.203.255
yc-test-node-group_status = running
```
Задеплоить приложение, проверить IP:
```
$kubectl get ingress -n dev
NAME   CLASS    HOSTS   ADDRESS         PORTS     AGE
ui     <none>   *       62.84.116.251   80, 443   14m
```

Microservices Reddit in dev ui-5485d7bd5f-nnckv container


## PR checklist
 - [ ] Выставил label с номером домашнего задания
 - [x] Выставил label с темой домашнего задания
