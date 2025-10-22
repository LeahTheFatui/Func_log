% students.pl
% Представление 1: Отдельные факты для студентов, групп и оценок

% Факты: студент(ID, Фамилия, Группа)
student(1, 'Иванов', 101).
student(2, 'Петров', 101).
student(3, 'Сидоров', 102).
student(4, 'Кузнецов', 102).
student(5, 'Смирнов', 103).
student(6, 'Попов', 103).
student(7, 'Васильев', 104).
student(8, 'Николаев', 104).

% Факты: оценка(ID_Студента, Предмет, Оценка)
grade(1, 'Математика', 5).
grade(1, 'Физика', 4).
grade(1, 'Программирование', 5).
grade(2, 'Математика', 3).
grade(2, 'Физика', 2).
grade(2, 'Программирование', 4).
grade(3, 'Математика', 4).
grade(3, 'Физика', 5).
grade(3, 'Программирование', 3).
grade(4, 'Математика', 2).
grade(4, 'Физика', 2).
grade(4, 'Программирование', 2).
grade(5, 'Математика', 5).
grade(5, 'Физика', 5).
grade(5, 'Программирование', 5).
grade(6, 'Математика', 3).
grade(6, 'Физика', 4).
grade(6, 'Программирование', 4).
grade(7, 'Математика', 2).
grade(7, 'Физика', 3).
grade(7, 'Программирование', 4).
grade(8, 'Математика', 4).
grade(8, 'Физика', 4).
grade(8, 'Программирование', 5).

% 1. Получить таблицу групп и средний балл по каждой из групп
group_average :-
    write('=== Средний балл по группам ==='), nl,
    write('Группа | Средний балл'), nl,
    write('---------------------'), nl,
    findall(Group, student(_, _, Group), Groups),
    sort(Groups, UniqueGroups),
    process_groups(UniqueGroups).

process_groups([]).
process_groups([Group|Rest]) :-
    calculate_group_average(Group, Average),
    format('~w     | ~2f~n', [Group, Average]),
    process_groups(Rest).

calculate_group_average(Group, Average) :-
    findall(Grade, (student(StID, _, Group), grade(StID, _, Grade)), Grades),
    sum_list(Grades, Sum),
    length(Grades, Count),
    Count > 0,
    Average is Sum / Count.

% 2. Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)
failed_students_by_subject :-
    write('=== Студенты, не сдавшие экзамены по предметам ==='), nl, nl,
    findall(Subject, grade(_, Subject, _), Subjects),
    sort(Subjects, UniqueSubjects),
    process_subjects(UniqueSubjects).

process_subjects([]).
process_subjects([Subject|Rest]) :-
    write('Предмет: '), write(Subject), nl,
    write('Не сдали: '),
    findall(Name, (grade(StID, Subject, 2), student(StID, Name, _)), FailedStudents),
    (FailedStudents = [] -> 
        write('нет') ; 
        write_list(FailedStudents)
    ),
    nl, nl,
    process_subjects(Rest).

write_list([]).
write_list([X]) :- write(X).
write_list([X|Rest]) :- 
    write(X), 
    (Rest = [] -> true ; write(', ')),
    write_list(Rest).

% 3. Найти количество не сдавших студентов в каждой из групп
failed_count_by_group :-
    write('=== Количество не сдавших студентов по группам ==='), nl,
    write('Группа | Кол-во не сдавших'), nl,
    write('--------------------------'), nl,
    findall(Group, student(_, _, Group), Groups),
    sort(Groups, UniqueGroups),
    count_failed_by_groups(UniqueGroups).

count_failed_by_groups([]).
count_failed_by_groups([Group|Rest]) :-
    findall(StID, (student(StID, _, Group), grade(StID, _, 2)), FailedIDs),
    sort(FailedIDs, UniqueFailed), % Убираем дубликаты (студент мог не сдать несколько предметов)
    length(UniqueFailed, Count),
    format('~w     | ~w~n', [Group, Count]),
    count_failed_by_groups(Rest).

% Утилитарные предикаты
sum_list([], 0).
sum_list([H|T], Sum) :-
    sum_list(T, TailSum),
    Sum is H + TailSum.

% Главный предикат для запуска всех отчетов
run_all_reports :-
    group_average, nl, nl,
    failed_students_by_subject, nl, nl,
    failed_count_by_group.

% Альтернативные представления данных (для демонстрации)

% Представление 2: Вложенная структура
% student_group(Группа, [студент(Фамилия, [оценка(Предмет, Оценка)])])

% Представление 3: Единая таблица
% record(Группа, Фамилия, Предмет, Оценка)

% Представление 4: Разделение по группам
% group(Группа, [student(Фамилия, Grades)])
% grades([grade(Предмет, Оценка)])
