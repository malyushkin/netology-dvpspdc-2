"""GitHub Markdown README generator"""

from datetime import datetime
import sys
import yaml

FILE = dict(yml_name="course.yaml",
            md_name="README.md")

KEY = dict(code_key="code",
           exams_key="exams",
           lessons_key="lessons",
           result_key="result",
           task_key="task",
           title_key="title")


def write_md_section_title(section_title):
    """Write course section title in Markdown"""
    md.write(f"## {section_title}")
    md.write("\n\n")


def write_md_section_list(section_list):
    """Write course section list in Markdown"""
    for section_list_item in section_list:
        if section_list_item[KEY['result_key']]:
            md.write(f"1. [{section_list_item[KEY['title_key']]}]"\
                     f"({section_list_item[KEY['result_key']]})")
        else:
            md.write(f"1. {section_list_item[KEY['title_key']]}")
            print(f"\033[1m{datetime.now()}\033[0m\t{section_list_item[KEY['code_key']]}"\
                  f"\tkey '{KEY['result_key']}' is null")

        if section_list_item[KEY['task_key']]:
            md.write(f" | [Задание]({section_list_item[KEY['task_key']]})")
            md.write("\n")
        else:
            md.write("\n")
            print(f"\033[1m{datetime.now()}\033[0m\t{section_list_item[KEY['code_key']]}"\
                  f"\tkey '{KEY['task_key']}' is null")

    md.write("\n")


with open(FILE['yml_name'], "r", encoding="utf-8") as yml:
    course = yaml.safe_load(yml)

with open(FILE['md_name'], "w", encoding="utf-8") as md:
    md.write(f"# {course[KEY['title_key']]}")
    md.write("\n\n")

    if "sections" not in course:
        sys.exit()

    # Sections
    for section in course['sections']:
        write_md_section_title(section[KEY['title_key']])

        # Lessons
        if KEY['lessons_key'] in section:
            md.write("### Практические задания")
            md.write("\n\n")
            write_md_section_list(section[KEY['lessons_key']])

        # Exams
        if KEY['exams_key'] in section:
            md.write("### Итоговая работа по модулю")
            md.write("\n\n")
            write_md_section_list(section[KEY['exams_key']])
