import psycopg2 as lib


DBNAME = "postgres"
USER = "postgres"
PASSWORD = "12345"
HOST = "localhost"
PORT = 5432


def student_data(t_username, s_name, s_class_name, s_gender, s_password, s_username):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from register_student(%(p1)s, %(p2)s, %(p3)s, %(p4)s, %(p5)s, %(p6)s)",
                    {"p1": t_username, "p2": s_name, "p3": s_class_name, "p4": s_gender, "p5": s_password, "p6": s_username})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def parent_data(t_username, p_name, p_gender, p_phone, p_password, p_username):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from register_parent(%(p1)s, %(p2)s, %(p3)s, %(p4)s, %(p5)s, %(p6)s)",
                    {"p1": t_username, "p2": p_name, "p3": p_gender, "p4": p_phone, "p5": p_password, "p6": p_username})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def link_accounts(t_username, p_username, s_username):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from link_student_parent(%(p1)s, %(p2)s, %(p3)s)",
                    {"p1": t_username, "p2": p_username, "p3": s_username})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def homework_data(t_username, date_on, class_name, lesson, text):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from add_homework(%(p1)s, %(p2)s, %(p3)s, %(p4)s, %(p5)s)",
                    {"p1": t_username, "p2": date_on, "p3": class_name, "p4": lesson, "p5": text})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def mark_data(t_username, mrk_day, mrk_mark, mrk_student, mrk_lesson):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from add_mark(%(p1)s, %(p2)s, %(p3)s, %(p4)s, %(p5)s)",
                    {"p1": t_username, "p2": mrk_day, "p3": mrk_mark, "p4": mrk_student, "p5": mrk_lesson})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def rebuke_data(t_username, day, student, lesson, text):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        cur.execute("select * from add_rebuke(%(p1)s, %(p2)s, %(p3)s, %(p4)s, %(p5)s)",
                    {"p1": t_username, "p2": day, "p3": student, "p4": lesson, "p5": text})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def get_homework(s_username, date_on):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("  Урок        Задание")

        cur.execute("select lesson, text from homework where date_on = %(p1)s and class_name = (select class_name from students where username = %(p2)s)",
                    {"p1": date_on, "p2": s_username})

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def get_marks(s_username):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("  День          Урок      Отметка")

        cur.execute("select day, lesson, mark from marks where student = %(p1)s order by day desc limit 10",
                    {"p1": s_username})

        for row in cur:
            r = list(row)
            r[0] = r[0].strftime("%d.%m.%Y")

            print(r)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

def get_rebukes(p_username):
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("Ребёнок       Дата          Урок        Замечание")

        cur.execute("select student, day, lesson, text from rebukes where student in (select student from students_parents_link where parent = %(p1)s) order by day desc limit 10",
                    {"p1": p_username})

        for row in cur:
            r = list(row)
            r[1] = r[1].strftime("%d.%m.%Y")

            print(r)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()


def register_student():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()


    t_username = input("Введите свой username: ")
    s_name = input("Введите ФИО ученика: ")
    s_class_name = input("Введите класс ученика: ")
    s_gender = input("Введите пол ученика: ")
    s_password = input("Введите пароль ученика: ")
    s_username = input("Введите username ученика: ")

    student_data(t_username, s_name, s_class_name, s_gender, s_password, s_username)

def register_parent():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()


    t_username = input("Введите свой username: ")
    p_name = input("Введите ФИО родителя: ")
    p_gender = input("Введите пол родителя: ")
    p_phone = input("Введите номер телефона родителя: ")
    p_password = input("Введите пароль родителя: ")
    p_username = input("Введите username родителя: ")

    parent_data(t_username, p_name, p_gender, p_phone, p_password, p_username)

def link_student_parent():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    t_username = input("Введите свой username: ")
    p_username = input("Введите username родителя: ")
    s_username = input("Введите username ученика: ")

    link_accounts(t_username, p_username, s_username)

def add_homework():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    t_username = input("Введите свой username: ")
    date_on = input("Введите дату: ")
    class_name = input("Введите класс: ")
    lesson = input("Введите название урока: ")
    text = input("Введите текст ДЗ: ")

    homework_data(t_username, date_on, class_name, lesson, text)

def add_mark():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    t_username = input("Введите свой username: ")
    mrk_day = input("Введите дату: ")

    try:
        mrk_mark = int(input("Введите отметку: ") )
    except ValueError:
        print("Введите число!")
        exit(1)

    mrk_student = input("Введите username ученика: ")
    mrk_lesson = input("Введите название урока: ")

    mark_data(t_username, mrk_day, mrk_mark, mrk_student, mrk_lesson)

def add_rebuke():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from teachers")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    t_username = input("Введите свой username: ")
    day = input("Введите дату: ")
    student = input("Введите username ученика: ")
    lesson = input("Введите название урока: ")
    text = input("Введите текст замечания: ")

    rebuke_data(t_username, day, student, lesson, text)

def view_homework():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from students")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    s_username = input("Введите свой username: ")
    date_on = input("Введите дату: ")

    get_homework(s_username, date_on)

def view_marks():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from students")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    s_username = input("Введите свой username: ")

    get_marks(s_username)

def view_rebukes():
    conn = lib.connect(host=HOST, port=PORT, user=USER, password=PASSWORD, database=DBNAME)
    cur = conn.cursor()

    try:
        print("    ФИО       username")

        cur.execute("select name, username from parents")

        for row in cur:
            print(row)

        conn.commit()
    except (Exception, lib.DatabaseError) as error:
        print(error)
    finally:
        cur.close()

        if conn is not None:
            conn.close()

    p_username = input("Введите свой username: ")

    get_rebukes(p_username)


def main():
    actions = {
        "Зарегестрировать ученика": register_student,
        "Зарегестрировать родителя": register_parent,
        "Свзать аккаунты ученика и родителя\n": link_student_parent,

        "Добавить домашнее задание": add_homework,
        "Добавить отметку": add_mark,
        "Добавить замечание\n": add_rebuke,

        "Просмотр ДЗ": view_homework,
        "Просмотр отметок\n": view_marks,

        "Просмотр замечаний": view_rebukes
    }

    print("Выберите действие:")

    for num, k in enumerate(actions.keys() ):
        print(f"{num + 1}) {k}")

    try:
        action = int(input(": ") )
    except ValueError:
        print("Введите число!")
        exit(1)

    try:
        actions[list(actions.keys())[action - 1]]()
    except KeyError:
        print("Неверное действие!")
        exit(1)

main()