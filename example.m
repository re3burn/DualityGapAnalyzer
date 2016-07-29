V_arr = [];
options = optimset('Simplex','on','LargeScale','off');
alpha_arr = 0 : 0.1 : 1;
for alpha = alpha_arr
	% Целевой вектор
	c = [1; 2*alpha - 1; 0];
	% Матрица и вектор ограничений, не содержащих n 
	A = [1 1 0; 1 -1 0];
	b = [1; 1];
	% Вектор для решения задач (1.5), (1.6), (2.15), (2.16) 
	V=zeros(1, 4);
	% Начальное приближение
	x0 = [2; 0; 0];
	f = @(x)objfun(x, c);
	% Решение задачи (1.5)
	[x, v] = fseminf(f, x0, 2, @confun1, -A, -b);
	V(1) = v;
	% Решение задачи (2.15)
	f = @(x)objfun(x, -c);
	x0 = [1; 0; 0];
	[x, v] = fseminf(f, x0, 2, @confun2, A, b);
	V(4) = -v;
	% Лимитирование количества ограничений, содержащих параметр n
	n = 10000;
	% Дополнение матрицы A и вектора b полубесконечными огранич-ми 
	for i = 2 : n
		A = [A; 1-1/i 1 1/i; 1-1/i -1 1/i];
    	b = [b; 2; 2];
	end
	% Решение задачи (1.6)
	[u, v] = linprog(-b', [], [], A', c, zeros(size(b,1), 1), [], [], options);
	V(2) = -v;
	% Решение задачи (2.16)
	[u, v] = linprog(b',[],[],A', c, zeros(size(b,1), 1), [], [], options);
	V(3) = v;
	% Сохранение соотношений двойственности для очередного alpha
	V_arr = [V_arr, V'];
end
% Построение графика
plot(alpha_arr, V_arr);
