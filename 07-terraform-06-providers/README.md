# Практическое задание по теме «Написание собственных провайдеров для Terraform»

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  

1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 


### Ход работы

1. Доступные [resource](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L913) и [data_source](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L415).
2. Ресурс `aws_sqs_queue` определяется функцией `ResourceQueue()`:

   * Согласно [исходному коду](https://github.com/hashicorp/terraform-provider-aws/blob/1bc96e19dbfa95a1e426f8e89c11e42928438eb0/internal/service/sqs/queue.go#L87), параметр `name` конфликтует с `name_prefix`.
   * Согласно [исходному кому](https://github.com/hashicorp/terraform-provider-aws/blob/1bc96e19dbfa95a1e426f8e89c11e42928438eb0/internal/service/sqs/queue.go#L427), максимальная длина равна 80 символам.
   * Регулярное выражение: `^[a-zA-Z0-9_-]`.
