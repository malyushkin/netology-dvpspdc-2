# netology-dvpspcd-2

## 02-git-01-vcs

В каталоге [terraform](https://github.com/malyushkin/netology-dvpspdc-2/tree/main/02-git-01-vcs/terraform) создан файл `.gitignore` с конфигурацией [Terraform.gitignore](https://github.com/github/gitignore/blob/master/Terraform.gitignore). В результате внутри каталога terraform git не будет учитывать любые изменения для файлов/каталогов:

* Все подкаталоги `.terraform`.
* Файлы с расширением `.tfstate` и `.tfstate.*`.
* Файл лога `crash.log`.
* Файлы с расширением `.tfvars` (файлы с чувствительными данными).
* Файлы переопределения `override.tf` и др.
* Файлы командной строки `.terraformrc` и `terraform.rc`.

## 02-git-02-base

New line