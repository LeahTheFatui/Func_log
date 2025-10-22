% Часть 1: Предикаты работы со списками
% Файл: task1.pl

% === Базовые предикаты обработки списков ===

% 1. length/2 - вычисление длины списка
% Способ 1: Без использования стандартных предикатов
my_length([], 0).
my_length([_|T], N) :- 
    my_length(T, N1), 
    N is N1 + 1.

% 2. member/2 - проверка принадлежности элемента списку
% Способ 1: Без использования стандартных предикатов
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

% 3. append/3 - конкатенация списков
% Способ 1: Без использования стандартных предикатов
my_append([], L, L).
my_append([H|T], L, [H|R]) :- my_append(T, L, R).

% 4. remove/3 - удаление элемента из списка
% Способ 1: Без использования стандартных предикатов
my_remove(X, [X|T], T).
my_remove(X, [H|T], [H|R]) :- 
    X \= H, 
    my_remove(X, T, R).

% 5. permute/2 - генерация перестановок списка
% Способ 1: Без использования стандартных предикатов
my_permute([], []).
my_permute(L, [X|P]) :- 
    my_remove(X, L, R),
    my_permute(R, P).

% 6. sublist/2 - проверка, является ли список подсписком другого
% Способ 1: Без использования стандартных предикатов
my_sublist(S, L) :- 
    my_append(_, T, L),
    my_append(S, _, T).

% === Специальный предикат обработки списка ===
% Удаление трех последних элементов

% Способ 1: С использованием стандартных предикатов
remove_last_three_std(List, Result) :-
    length(List, Len),
    Len >= 3,
    PrefixLen is Len - 3,
    length(Prefix, PrefixLen),
    append(Prefix, _, List),
    Result = Prefix.

% Способ 2: Без использования стандартных предикатов
remove_last_three(List, Result) :-
    remove_last_three_helper(List, Result).

remove_last_three_helper([_,_,_], []).
remove_last_three_helper([H|T], [H|R]) :-
    remove_last_three_helper(T, R).

% === Предикат обработки числового списка ===
% Вычисление числа вхождений первого элемента

% Способ 1: С использованием стандартных предикатов
count_first_std([], 0).
count_first_std([First|Tail], Count) :-
    count_occurrences_std([First|Tail], First, Count).

count_occurrences_std(List, Element, Count) :-
    include(=(Element), List, Filtered),
    length(Filtered, Count).

% Способ 2: Без использования стандартных предикатов
count_first([], 0).
count_first([First|Tail], Count) :-
    count_occurrences([First|Tail], First, 0, Count).

count_occurrences([], _, Acc, Acc).
count_occurrences([H|T], Element, Acc, Count) :-
    (H =:= Element ->
        NewAcc is Acc + 1
    ; 
        NewAcc = Acc
    ),
    count_occurrences(T, Element, NewAcc, Count).

% === Пример совместного использования предикатов ===
% Обработка списка: удаляем три последних элемента, затем считаем 
% количество вхождений первого элемента в оставшемся списке

process_list(List, ProcessedList, FirstElemCount) :-
    % Удаляем три последних элемента
    remove_last_three(List, ProcessedList),
    % Считаем количество вхождений первого элемента
    count_first(ProcessedList, FirstElemCount).

% === Тестовые примеры и демонстрация ===

% Демонстрация базовых предикатов
test_basic_predicates :-
    write('=== Тестирование базовых предикатов ==='), nl, nl,
    
    % Тест my_length
    write('1. Тест my_length:'), nl,
    my_length([a,b,c,d], Len1), write('Длина [a,b,c,d]: '), write(Len1), nl,
    my_length([], Len2), write('Длина []: '), write(Len2), nl, nl,
    
    % Тест my_member
    write('2. Тест my_member:'), nl,
    (my_member(b, [a,b,c]) -> write('b принадлежит [a,b,c]'), nl ; true),
    (my_member(x, [a,b,c]) -> write('x принадлежит [a,b,c]'), nl ; write('x не принадлежит [a,b,c]'), nl), nl,
    
    % Тест my_append
    write('3. Тест my_append:'), nl,
    my_append([1,2], [3,4], Result1), write('append([1,2], [3,4], '), write(Result1), write(')'), nl, nl,
    
    % Тест my_remove
    write('4. Тест my_remove:'), nl,
    my_remove(b, [a,b,c,b], Result2), write('remove(b, [a,b,c,b], '), write(Result2), write(')'), nl, nl,
    
    % Тест my_permute
    write('5. Тест my_permute:'), nl,
    my_permute([1,2,3], Perm), write('permute([1,2,3], '), write(Perm), write(')'), nl, nl,
    
    % Тест my_sublist
    write('6. Тест my_sublist:'), nl,
    (my_sublist([b,c], [a,b,c,d]) -> write('[b,c] является подсписком [a,b,c,d]'), nl ; true),
    (my_sublist([x,y], [a,b,c,d]) -> write('[x,y] является подсписком [a,b,c,d]'), nl ; write('[x,y] не является подсписком [a,b,c,d]'), nl), nl.

% Демонстрация специальных предикатов
test_special_predicates :-
    write('=== Тестирование специальных предикатов ==='), nl, nl,
    
    % Тест удаления трех последних элементов
    write('1. Удаление трех последних элементов:'), nl,
    remove_last_three([1,2,3,4,5,6], Result1), 
    write('remove_last_three([1,2,3,4,5,6], '), write(Result1), write(')'), nl,
    
    remove_last_three_std([a,b,c,d,e], Result2), 
    write('remove_last_three_std([a,b,c,d,e], '), write(Result2), write(')'), nl, nl,
    
    % Тест подсчета первого элемента
    write('2. Подсчет вхождений первого элемента:'), nl,
    count_first([3,3,1,2,3,3], Count1),
    write('count_first([3,3,1,2,3,3], '), write(Count1), write(')'), nl,
    
    count_first_std([5,2,5,8,5], Count2),
    write('count_first_std([5,2,5,8,5], '), write(Count2), write(')'), nl, nl.

% Демонстрация совместного использования
test_combined_usage :-
    write('=== Совместное использование предикатов ==='), nl, nl,
    
    write('Пример 1:'), nl,
    process_list([1,1,2,3,1,4,5], Processed1, Count1),
    write('Исходный список: [1,1,2,3,1,4,5]'), nl,
    write('После удаления 3 последних: '), write(Processed1), nl,
    write('Количество вхождений первого элемента (1): '), write(Count1), nl, nl,
    
    write('Пример 2:'), nl,
    process_list([7,7,7,8,9,10,11], Processed2, Count2),
    write('Исходный список: [7,7,7,8,9,10,11]'), nl,
    write('После удаления 3 последних: '), write(Processed2), nl,
    write('Количество вхождений первого элемента (7): '), write(Count2), nl, nl,
    
    write('Пример 3 (граничный случай):'), nl,
    process_list([2,2,2], Processed3, Count3),
    write('Исходный список: [2,2,2]'), nl,
    write('После удаления 3 последних: '), write(Processed3), nl,
    write('Количество вхождений первого элемента (2): '), write(Count3), nl.

% Запуск всех тестов
run_all_tests :-
    test_basic_predicates,
    test_special_predicates,
    test_combined_usage.

% === Дополнительные примеры запросов для ручного тестирования ===

% Примеры запросов для remove_last_three:
% ?- remove_last_three([1,2,3,4,5,6], R).    % R = [1,2,3]
% ?- remove_last_three([a,b,c], R).           % R = []
% ?- remove_last_three([a,b], R).             % false

% Примеры запросов для count_first:
% ?- count_first([3,3,1,3,2], C).            % C = 3
% ?- count_first([5], C).                    % C = 1
% ?- count_first([], C).                     % C = 0

% Примеры запросов для process_list:
% ?- process_list([1,1,2,1,3,4,5], P, C).   % P = [1,1,2,1], C = 3
