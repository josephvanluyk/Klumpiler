#include "../../scanner/scanner.h"
#include "stdlib.h"
token tok(0, "", "");

/*
	One function for each non-terminal
	If it returns false, that means it failed to find the sequence of tokens to make up its namesake
	If it returns true, then it parsed properly.

	Example:
		dcl_definitions() returns true means that if was able to find a "dcl_definitions" in the code
		mulop() returns false means it couldn't find a mulop.
*/
bool pal_program();
bool dcl_definitions();
bool procedure();
bool dcl_list();
bool statement_list();
bool statement();
bool assignment_statement();
bool write_statement();
bool expression();
bool term();
bool more_expression();
bool factor();
bool more_term();
bool mulop();
bool addop();

void error();

int main(){
	sym = nextSym();
	tok = getNext();

	//Can we find a pal_progr	am?
	bool parses = pal_program();

	//If so, we're good. Otherwise, error()
	if(parses){
		std::cout << "Successfully parsed." << std::endl;
	}else{
		error();
	}
}

bool pal_program(){
		//A pal_program consists of dcl_definitions followed by a procedure.
			//If we can't find both of those in a row, we don't have a pal_program.
		if(dcl_definitions()){
			if(procedure()){
				return true;
			}
			error();
		}
		return false;
}


bool dcl_definitions(){
	//A dcl_definitions is either the dcl lexeme followed by a dcl_list
		//Or it's nothing. If we see a dcl lexeme but no dcl_list, it's not a dcl_definitions.
	if(tok.lexeme == "dcl"){
		tok = getNext();
		if(dcl_list()){
			return true;
		}
		error();
	}else{
		return true;
	}

	return false;
}

bool procedure(){
	//A procedure is a begin lexeme followed by a statement_list followed by "end" followed by "."
	//If we don't find all of those things in order, it's not a procedure.
	if(tok.lexeme == "begin"){
		tok = getNext();
		if(statement_list()){
			if(tok.lexeme == "end"){
				tok = getNext();
				if(tok.lexeme == "."){
					tok = getNext();
					return true;
				}
			}
		}
		error();
	}
	return false;
}

bool dcl_list(){
	//A dcl_list is an identifier, ";", "int", ";", dcl_list.
	//Or it's nothing.
	//If neither of those are the case, it's not a dcl_list.
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		if(tok.lexeme == ":"){
			tok = getNext();
			if(tok.lexeme == "int"){
				tok = getNext();
				if(tok.lexeme == ";"){
					tok = getNext();
					if(dcl_list()){
						return true;
					}
				}
			}
		}
		error();
	}else{
		return true;
	}

	return false;
}


bool statement_list(){
	//Statement lists are a statement followed by a statement_list
	//Or they're nothing
	//Otherwise, it's not a statement_list
	if(statement()){
		if(statement_list()){
			return true;
		}
		error();
	}else{
		return true;
	}

	return false;

}


bool statement(){
	//A statement is either an asignment_statement or a write_statement. Otherwise, it's not a statement.
	if(assignment_statement()){
		return true;
	}else if(write_statement()){
		return true;
	}else{
		return false;
	}
}

bool assignment_statement(){
	//An assignment_statement is an identifier followed by ":=" followed by an expression followed by ";"
	//If we don't see all those in order, return false.
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		if(tok.lexeme == ":="){
			tok = getNext();
			if(expression()){
				if(tok.lexeme == ";"){
					tok = getNext();
					return true;
				}
			}
		}
		error();
	}

	return false;
}


bool write_statement(){
	//A write_statement is "writeln" followed by "(" followed by an identifier followed by ")" followed by ";".
	//if we don't find all of those in order, return false.
	if(tok.lexeme == "writeln"){
		tok = getNext();
		if(tok.lexeme == "("){
			tok = getNext();
			if(tok.tokenName == "Identifier"){
				tok = getNext();
				if(tok.lexeme == ")"){
					tok = getNext();
					if(tok.lexeme == ";"){
						tok = getNext();
						return true;
					}
				}
			}
		}
		error();
	}

	return false;
}


bool expression(){
	//An expession is a term followed by a more_expression.
		//If we don't find that in order, return false.
	if(term()){
		if(more_expression()){
			return true;
		}
		error();
	}

	return false;
}

bool more_expression(){
	//A more_expression is an addop followed by a term followed by a more_expresion
	//Or it's nothing.
	//If we a see an addop not followed by a term and expression, return false.
	if(addop()){
		if(term()){
			if(more_expression()){
				return true;
			}
		}
		error();
	}

	return true;
}
bool term(){
	//A term is a factor followed by a more_term.
	//If we don't see those in order, return false.
	if(factor()){
		if(more_term()){
			return true;
		}
		error();
	}
	return false;
}

bool more_term(){
	//A more_term is a mulop followed by a factor followed by a more_term.
	//Or it's nothing.
	//If we a see am mulop but not a factor/more_term, return false.
	if(mulop()){
		if(factor()){
			if(more_term()){
				return true;
			}
		}
		error();
	}

	return true;
}

bool factor(){
	//A factor is an identifier or an integer.
	//Or it's "(" followed by an expression followed by ")".
	//If none of those work, return false.
	if(tok.tokenName == "Identifier"){
		tok = getNext();
		return true;
	}else if(tok.tokenName == "integer"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "("){
		tok = getNext();
		if(expression()){
			if(tok.lexeme == ")"){
				tok = getNext();
				return true;
			}
		}
	}

	return false;
}

//An addop is "+" or "-".
//If we don't find that, return false.
bool addop(){
	if(tok.lexeme == "+"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "-"){
		tok = getNext();
		return true;
	}

	return false;
}

//A mulop is "*" or "/".
//If we don't find that, return false.
bool mulop(){
	if(tok.lexeme == "*"){
		tok = getNext();
		return true;
	}else if(tok.lexeme == "/"){
		tok = getNext();
		return true;
	}
	return false;
}

//If there's an error, report the line number and where we encountered something unexpected
void error(){
	std::cout << "Error on line " << tok.lineNumber << std::endl;
	std::cout << "Unexpected token: " << tok.lexeme << std::endl;
	exit(EXIT_FAILURE);
}
