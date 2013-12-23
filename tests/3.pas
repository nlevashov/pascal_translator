program example(input, output);
var a, n, i, answer: integer;
begin
	a := 2;
	n := 6;

	{ возвдение a в степень n }
	
	i := 0;
	answer := 1;
	while (i <> n) do
	begin
		answer := answer * a;
		i := i + 1
	end;
	write(answer)
end.