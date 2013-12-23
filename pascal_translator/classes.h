#ifndef __HEADER
#define __HEADER

#include <string>
#include <vector>
#include <iostream>

using namespace std;

string get_str(int number);

class Smart_string {
	string _s;
	int    _type;
	bool   _less, _equal, _greater;
	int    _shift, _shift_if_true, _shift_if_false;
	bool   _is_set_shift_if_true, _is_set_shift_if_false;

public:
	Smart_string(string s) : _s(s), _type(0), _is_set_shift_if_true(true), _is_set_shift_if_false(true) {}
	Smart_string(string s, int shift) : _s(s), _type(1), _shift(shift), _is_set_shift_if_true(true), _is_set_shift_if_false(true) {}
	Smart_string(string s, bool less, bool equal, bool greater) : _s(s), _type(2), _less(less), _equal(equal), _greater(greater),
				                                                  _is_set_shift_if_true(false), _is_set_shift_if_false(false) {}

	void reverse() {
		if (_type == 2) {
			_less = !_less;
			_equal = !_equal;
			_greater = !_greater;

			int temp = _shift_if_true;
			_shift_if_true = _shift_if_false;
			_shift_if_false = temp;
		}
	}

	void set_shift_if_true(int shift) {
		if (!_is_set_shift_if_true) {
			_shift_if_true = shift;
			_is_set_shift_if_true = true;
		}
	}

	void set_shift_if_false(int shift) {
		if (!_is_set_shift_if_false) {
			_shift_if_false = shift;
			_is_set_shift_if_false = true;
		}
	}

	void print(int current_step) {
		switch (_type) {
			case 0:
				cout << _s << endl;
				break;
			case 1:
				cout << _s << " " << (current_step + _shift - 1) << endl;
				break;
			case 2:
				cout << _s;
				if (_less)    cout << " " << (current_step - 1 + _shift_if_true);
				else 	      cout << " " << (current_step - 1 + _shift_if_false);
				if (_equal)   cout << " " << (current_step - 1 + _shift_if_true);
				else 	      cout << " " << (current_step - 1 + _shift_if_false);
				if (_greater) cout << " " << (current_step - 1 + _shift_if_true);
				else 	      cout << " " << (current_step - 1 + _shift_if_false);
				cout << endl;
		}
	}
};


class Var {
	string _name;
	vector<Smart_string> _commands;

public:
	Var() {}

	Var(string name) : _name(name) {}
	
	Var(string name, Var v) : _name(name) {
		_commands.insert(_commands.end(), v._commands.begin(), v._commands.end());
	}

	Var(string name, Var v1, Var v2) : _name(name) {
		_commands.insert(_commands.end(), v1._commands.begin(), v1._commands.end());
		_commands.insert(_commands.end(), v2._commands.begin(), v2._commands.end());
	}

	Var(string name, Var v1, Var v2, Var v3) : _name(name) {
		_commands.insert(_commands.end(), v1._commands.begin(), v1._commands.end());
		_commands.insert(_commands.end(), v2._commands.begin(), v2._commands.end());
		_commands.insert(_commands.end(), v3._commands.begin(), v3._commands.end());
	}
	
	string name() {
		return _name;
	}

	void add(string s) {
		_commands.push_back(Smart_string(s));
	}

	void add(string s, int shift) {
		_commands.push_back(Smart_string(s, shift));
	}

	void add(string s, bool less, bool equal, bool greater) {
		_commands.push_back(Smart_string(s, less, equal, greater));
	}

	void set_shift_if_true(int shift) {
		for (int i = 0; i < _commands.size(); i++) _commands[i].set_shift_if_true(_commands.size() - i + shift);
	}

	void set_shift_if_false(int shift) {
		for (int i = 0; i < _commands.size(); i++) _commands[i].set_shift_if_false(_commands.size() - i + shift);
	}

	void reverse() {
		for (auto c : _commands) c.reverse();
	}

	int length() {
		return _commands.size();
	}

	void print() {
		for (int i = 0; i < _commands.size(); i++) _commands[i].print(i);
	}
};


class Variables {
	int _temp_var_number;

public:
	Variables() : _temp_var_number(0) {}
	
	Var * get_new() {
		_temp_var_number++;
		return new Var("arg" + get_str(_temp_var_number));
	}

	Var * get_new(Var * v) {
		_temp_var_number++;
		return new Var("arg" + get_str(_temp_var_number), *v);
	}

	Var * get_new(Var * v1, Var * v2) {
		_temp_var_number++;
		return new Var("arg" + get_str(_temp_var_number), *v1, *v2);
	}

	Var * get_new(Var * v1, Var * v2, Var * v3) {
		_temp_var_number++;
		return new Var("arg" + get_str(_temp_var_number), *v1, *v2, *v3);
	}
};


extern Variables variables;


class Var_list {
	vector<Var> _variables;

public:
	void add(Var * v) {
		_variables.push_back(*v);
	}

	Var * get_list_for_printing() {
		Var * v = variables.get_new();
		for (auto i : _variables) {
			v = variables.get_new(v, &i);
			v->add("out " + i.name());
		}
		return v;
	}
};

int yylex();
void yyerror(string s);

#include "syntax.tab.h"
#endif
