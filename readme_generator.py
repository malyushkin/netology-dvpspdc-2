import yaml
from datetime import datetime

yml_name = "course.yaml"
md_name = "README.md"

code_key = "code"
exams_key = "exams"
lessons_key = "lessons"
result_key = "result"
task_key = "task"
title_key = "title"

with open(yml_name, "r") as yml:
    course = yaml.safe_load(yml)

with open(md_name, "w") as md:
    # Course title
    md.write(f"# {course[title_key]}")
    md.write("\n")

    # Section title
    for section in course['sections']:
        md.write("\n")
        md.write(f"## {section[title_key]}")
        md.write("\n\n")

        if lessons_key in section:
            # Lessons title
            md.write(f"### Практические задания")
            md.write("\n\n")

            for lesson in section[lessons_key]:
                if lesson[result_key]:
                    md.write(f"1. [{lesson[title_key]}]({lesson[result_key]})")
                else:
                    md.write(f"1. {lesson[title_key]}")
                    print(f"\033[1m{datetime.now()}\033[0m\t{lesson[code_key]}\tkey '{result_key}' is null")

                if lesson[task_key]:
                    md.write(f" | [Задание]({lesson[task_key]})")
                    md.write("\n")
                else:
                    md.write("\n")
                    print(f"\033[1m{datetime.now()}\033[0m\t{lesson[code_key]}\tkey '{task_key}' is null")

            md.write("\n")

        if exams_key in section:
            # Exams title
            md.write(f"### Итоговая работа по модулю")
            md.write("\n\n")

            for exam in section[exams_key]:
                if exam[result_key]:
                    md.write(f"[{exam[title_key]}]({exam[result_key]})")
                else:
                    md.write(f"{exam[title_key]}")
                    print(f"\033[1m{datetime.now()}\033[0m\t{exam[code_key]}\tkey '{result_key}' is null")

                if exam[task_key]:
                    md.write(f" | [Задание]({exam[task_key]})")
                    md.write("\n")
                else:
                    md.write("\n")
                    print(f"\033[1m{datetime.now()}\033[0m\t{exam[code_key]}\tkey '{task_key}' is null")
