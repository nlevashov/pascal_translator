program example(input, output);
var x, y, r: integer;
begin
	r := 5;
	x := 3;
	y := 4;
	
	{ проверка, лежит ли точка (x,y) в 1й или 3й четверти круга радиуса r, расположенного в начале координат }
	if (x * x + y * y <= r * r) and (x >= 0 and y >= 0 or x <= 0 and y <= 0) then write(1)
	else begin
		write(0)
	end;

	{ с использованием отрицания: }
	if (x * x + y * y <= r * r) and not (x < 0 and y > 0 or x > 0 and y < 0) then write(1)
	else begin
		write(12 - 4 * 3)
	end
end.