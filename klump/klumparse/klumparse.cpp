#include "../../scanner/scanner.h"
const int FOUND = 1;
const int DOES_NOT_MATCH = 0;
const int FAILED = -1;
token tok(0, "", "");
int klump_program();
int global_definitions();
int const_definitions();
int const_list();
int _const();
int type_definitions();
int type_list();
int struct_type();
int array_type();
int record_type();
int fld_list();
int dcl_definitions();
int dcl_list();
int dcl_type();
int atomic_type();
int proc_declarations();
int signature_list();
int proc_signature();
int formal_args();
int formal_arg_list();
int formal_arg();
int call_by();
int return_type();
int actual_args();
int actual_arg_list();
int actual_arg();
int procedure_list();
int procedure();
int proc_head();
int proc_body();
int statement_list();
int statement();
int label();
int exec_statement();
int read_statement();
int write_statement();
int assign_statement();
int call_statement();
int return_statement();
int goto_statement();
int empty_statement();
int compound_statement();
int if_statement();
int else_clause();
int while_statement();
int case_statement();
int case_list();
int for_statement();
int next_statement();
int break_statement();
int expression();
int comparison();
int simple_expression();
int term();
int factor();
int compop();
int addop();
int mulop();
int unary();
int lval();
int func_ref();
int qualifier();
bool match_token(std::string a, std::string b);

bool match_token(std::string a, std::string b){
	if(a == b){
		tok = getNext();
		return true;
	}
	return false;
}

int main(){
	sym = nextSym();
	tok = getNext();
	int parses = klump_program();
	if(parses == FOUND){
		std::cout << "Parsed Successfully" << std::endl;
	}
}


int klump_program(){
	if(global_definitions() == FOUND){
		if(procedure_list() == FOUND){
			if(match_token(tok.lexeme, ".")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}


int global_definitions(){
	if(tok.lexeme == "global"){
		tok = getNext();
		if(const_definitions() == FOUND && type_definitions() == FOUND && dcl_definitions() == FOUND && proc_declarations() == FOUND){
			return FOUND;
		}
		return FAILED;
	}else{
		return FOUND;
	}
}


int const_definitions(){
	if(tok.lexeme == "const"){
		tok = getNext();
		if(const_list()){
			return FOUND;
		}
		return FAILED;
	}
	return FOUND;
}


int const_list(){
	while(match_token(tok.lexeme, "{")){
		if(match_token(tok.tokenName, "Identifier")
			&& match_token(tok.lexeme, ":")
			&& _const() == FOUND
			&& match_token(tok.lexeme, ";")
			&& match_token(tok.lexeme, "}"))
		{

		}else{
			return FAILED;
		}
	}
	return FOUND;
}


int _const(){
	if(match_token(tok.tokenName, "number") || match_token(tok.tokenName, "decimal") || match_token(tok.tokenName, "cstring")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

int type_definitions(){
	if(match_token(tok.lexeme, "type")){
		if(type_list() == FOUND){
			return FOUND;
		}
		return FAILED;
	}
	return FOUND;
}

int type_list(){
	while(match_token(tok.lexeme, "{")){
		if(match_token(tok.tokenName, "Identifier")
			&& match_token(tok.lexeme, ":")
			&& struct_type() == FOUND
			&& match_token(tok.lexeme, ";")
			&& match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
	}
	return FOUND;
}


int struct_type(){
	int a = array_type();
	if(a == DOES_NOT_MATCH){
		return record_type();
	}

	return a;
}


int array_type(){
	if(match_token(tok.lexeme, "array")){
		if(match_token(tok.lexeme, "[")
		&& match_token(tok.tokenName, "number")
		&& match_token(tok.lexeme, "]")
		&& match_token(tok.lexeme, "of")
		&& dcl_type() == FOUND){
			return FOUND;
		}else{
			return FAILED;
		}
	}
	return DOES_NOT_MATCH;
}


int record_type(){
	if(match_token(tok.lexeme, "record")){
		if(fld_list() == FOUND && match_token(tok.lexeme, "end")){
			return FOUND;
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}


int fld_list(){
	while(match_token(tok.lexeme, "{")){
		if(match_token(tok.tokenName, "Identifier")
			&& match_token(tok.lexeme, ":")
			&& dcl_type() == FOUND
			&& match_token(tok.lexeme, ";")
			&& match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
	}
	return FOUND;
}

int dcl_definitions(){
	if(match_token(tok.lexeme, "dcl")){
		if(dcl_list() == FOUND){
			return FOUND;
		}else{
			return FAILED;
		}
	}
	return DOES_NOT_MATCH;
}


int dcl_list(){
	while(match_token(tok.lexeme, "{")){
		if(match_token(tok.tokenName, "Identifier")
			&& match_token(tok.lexeme, ":")
			&& dcl_type() == FOUND
			&& match_token(tok.lexeme, ";")
			&& match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
	}

	return FOUND;
}

int dcl_type(){
	int a = atomic_type();
	if(a == FOUND){
		return FOUND;
	}else if(a == FAILED){
		return FAILED;
	}else{
		if(match_token(tok.tokenName, "Identifier")){
			return FOUND;
		}else{
			return DOES_NOT_MATCH;
		}
	}
}


int atomic_type(){
	if(match_token(tok.lexeme, "bool") || match_token(tok.lexeme, "real")
		|| match_token(tok.lexeme, "real") || match_token(tok.lexeme, "string")){
			return FOUND;
		}
	return DOES_NOT_MATCH;
}

int proc_declarations(){
	if(match_token(tok.lexeme, "proc")){
		if(signature_list() == FOUND){
			return FOUND;
		}
		return FAILED;
	}
	return FOUND;
}

int signature_list(){
	while(match_token(tok.lexeme, "{")){
		if(match_token(tok.lexeme, ";")
			&& proc_signature() == FOUND
			&& match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
	}
	return FOUND;
}

int proc_signature(){
	if(match_token(tok.tokenName, "Identifier")){
		if(formal_args() == FOUND && return_type() == FOUND && match_token(tok.lexeme, ";")){
			return FOUND;
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int formal_args(){
	if(match_token(tok.lexeme, "(")){
		if(formal_arg_list() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return FOUND;
}

int formal_arg_list(){
	int a = formal_arg();
	if(a == FOUND){
		while(match_token(tok.lexeme, ",")){
			if(actual_arg() == FOUND && match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
		}
		return FOUND;
	}
	return a;
}

int formal_arg(){
	int a = call_by();
	if(a == FOUND){
		if(match_token(tok.tokenName, "Identifier") && match_token(tok.lexeme, ":") && dcl_type() == FOUND){
			return FOUND;
		}
		return FAILED;
	}
	return a;
}

int call_by(){
	if(match_token(tok.lexeme, "var")){
		return FOUND;
	}

	return FOUND;
}

int return_type(){
	int a = atomic_type();
	if(a == FAILED){
		return FAILED;
	}
	return FOUND;
}

int actual_args(){
	if(match_token(tok.lexeme, "(")){
		if(actual_arg_list() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int actual_arg_list(){
	int a = actual_arg();
	if(a == FOUND){
		while(match_token(tok.lexeme, "{")){
			if(match_token(tok.lexeme, ",") && actual_arg() == FOUND && match_token(tok.lexeme, "}")){

			}else{
				return FAILED;
			}
		}
	}
	return a;

}

int actual_arg(){
	return expression();
}

int procedure_list(){
	bool pass = false;
	while(match_token(tok.lexeme, "{")){
		if(procedure() == FOUND){
			if(match_token(tok.lexeme, "}")){
				pass = true;
			}
		}
		if(pass){
			pass = false;
		}else{
			return FAILED;
		}
	}
	return FOUND;
}

int procedure(){
	int a = proc_head();
	if(a == FOUND){
		if(proc_body() == FOUND){
			return FOUND;
		}
	}
	return a;
}

int proc_head(){
	if(match_token(tok.lexeme, "procedure")){
		if(match_token(tok.tokenName, "Identifier")){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int statement_list(){
	bool pass = false;
	while(match_token(tok.lexeme, "{")){
		if(statement() == FOUND){
			if(match_token(tok.lexeme, "}")){
				pass = true;
			}
		}
		if(!pass){
			return FAILED;
		}else{
			pass = false;
		}
	}
	return FOUND;
}

int statement(){
	int a = label();
	if(a == FOUND){
		if(exec_statement() == FOUND){
			return FOUND;
		}
		return FAILED;
	}
	return a;
}

int label(){
	if(match_token(tok.lexeme, "#")){
		if(match_token(tok.tokenName, "number")){
			return FOUND;
		}
		return FAILED;
	}
	return FOUND;
}

int exec_statement(){
	int result = read_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = write_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = assign_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = call_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = return_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = goto_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = empty_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = compound_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = if_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = while_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = case_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = for_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = next_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	result = break_statement();
	if(result == FOUND || result == FAILED){
		return result;
	}

	return DOES_NOT_MATCH;
}


int read_statement(){
	if(match_token(tok.lexeme, "read") || match_token(tok.lexeme, "readln")){
		if(actual_args() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int write_statement(){
	if(match_token(tok.lexeme, "write") || match_token(tok.lexeme, "writeln")){
		if(actual_args() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}


int assign_statement(){
	int a = lval();
	if(a == FOUND){
		if(match_token(tok.lexeme, ":=")){
			if(expression() == FOUND){
				if(match_token(tok.lexeme, ";")){
					return FOUND;
				}
			}
		}
		return FAILED;
	}
	return a;
}

int call_statement(){
	if(match_token(tok.lexeme, "call")){
		if(match_token(tok.tokenName, "Identifier")){
			if(actual_args() == FOUND){
				if(match_token(tok.lexeme, ";")){
					return FOUND;
				}
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int return_statement(){
	if(match_token(tok.lexeme, "return")){
		if(match_token(tok.lexeme, "[")){
			if(expression() == FOUND){
				if(match_token(tok.lexeme, "]")){
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}
				}
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int goto_statement(){
	if(match_token(tok.lexeme, "goto")){
		if(label() == FOUND){
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		return FAILED;
	}
	return DOES_NOT_MATCH;
}

int empty_statement(){
	if(match_token(tok.lexeme, ";")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}
