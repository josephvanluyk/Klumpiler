#include<iostream>
#include<string>
#include "token.h"
#include<vector>

std::string nextSym();
int n = 0;
std::string reservedWords[] = {"global", "const", "number", "decimal", "cstring", "type",
								"array", "of", "record", "end", "dcl", "bool", "int", "real",
								"string", "proc", "var", "procedure", "begin", "end", "read", "write",
								"readln", "writeln", "call", "return", "goto", "do", "if", "then", "else", "while"
								"case", "default", "for", "to", "downto", "next", "break", "not", "or", "and"};
std::string sym;


//REQUIRES: sym to be set up with nextSym()
token getNext(void){
//removewhitespace:
	//Remove all whitespace
	while((sym == " ") || (sym == "\n") || (sym == "	")){
		if(sym == "\n"){		//If there's a newline, increment line-count
			n++;
		}
		//std::cout << "I'm right here" << std::endl;
		sym = nextSym();
	}
	//Remove comments
	/*if(sym == "{"){
		sym = nextSym();
		while(sym != "}"){
			if(sym == "\n"){
				n++;
			}
			sym = nextSym();
		}
		sym = nextSym();
		goto removewhitespace;
	}*/

	/*
		At the end of the method, return token(n, tokenName, lexeme).
		In each else-if, set up the value of tokenName/lexeme to be returned
		later
	*/
	std::string tokenName;
	std::string lexeme;
	if(sym == "("){				//If our symbol is a left paren
		tokenName = "(";			//It is a left-paren token
		lexeme = "(";				//And the instance of that token is a left-paren
		sym = nextSym();			//Set up sym for the next getNext() call
	}else if(sym == ")"){		//Otherwise, if our symbol is a right-paren
		tokenName = ")";			//It's a right-paren token
		lexeme = ")";				//And the instance of that token is a right-paren
		sym = nextSym();			//Set up sym for the next getNext() call
	}else if(sym == "}" || sym == "{"){
		tokenName = sym;
		lexeme = sym;
		sym = nextSym();
	}else if(isalpha(sym.at(0))){								//Otherwise, if the symbol is alphabetic
		std::string potentialIdentifier = sym;
		sym = nextSym();
		while(isdigit(sym.at(0)) || isalpha(sym.at(0))){		//Add alphabetic characters until we reach whitespace/punctuation
			potentialIdentifier = potentialIdentifier + sym;
			sym = nextSym();
		}
		bool flag = false;
		for(int i = 0; i < sizeof(reservedWords)/sizeof(*reservedWords); i++){			//Determine whether we've found a KeyWord or identifier
			if(reservedWords[i] == potentialIdentifier){
				tokenName = "KeyWord";
				lexeme = potentialIdentifier;
				flag = true;									//Set a flag, so we don't overwrite the tokenName with identifier
			}
		}
		if(!flag){												//If the potentialIdentifier wasn't a keyword, set the tokenName
			tokenName = "Identifier";
			lexeme = potentialIdentifier;
		}
	}else if(sym == "\'"){							//If we find a ", we're looking at a string-literal
		std::string literal = "\'";
		sym = nextSym();
		while(sym != "\'"){							//Find the closing ". Until then, add on to the literal we've found.
			literal += sym;
			sym = nextSym();
		}
		literal += sym;
		if(literal.size() == 3){					//If its length is 3 (i.e. it's of the form "x"), then it's a char.
			tokenName = "Char";
		}else{										//Otherwise, it's a string
			tokenName = "String";
		}
		lexeme = literal;							//In either case, the lexeme is the literal we've found.
		sym = nextSym();
	}else if(sym == ":"){						//If the symbol is a colon, then we're looking for the assignment operator
		sym = nextSym();
		if(sym == "="){							//Check if the next symbol really is "="
			sym = nextSym();
			tokenName = ":=";
			lexeme = ":=";						//Set the token meta-data for an assignment operator
		}else{
			tokenName = ":";
			lexeme = ":";
		}
	}else if(isdigit(sym.at(0))){				//If the symbol is a digit, we need to see if it's an int or real
		std::string literal = sym;
		sym = nextSym();
		while(isdigit(sym.at(0))){				//Wait until we find a non-digit character
			literal += sym;
			sym = nextSym();
		}
		if(sym == "."){							//If it's a decimal, then we're looking at a real
			tokenName = "real";
			sym = nextSym();
			while(isdigit(sym.at(0))){
				literal += sym;
				sym = nextSym();
			}
		}else{									//Otherwise, it's integer
			tokenName = "integer";
		}
		lexeme = literal;						//In either case, the instance of the token is the literal
	}else if(sym == "."){				//A symbol of "." represents the end of the program
		tokenName = ".";
		lexeme = ".";
		sym = nextSym();
	}else if(sym == "="){		//If we're looking at an equals, it's an equals. Duh.
		tokenName = "Equals";
		lexeme = "=";
		sym = nextSym();
	}else if(sym == ";" || sym == "," || sym == "#" || sym == "[" || sym == "]"){		//If we're looking at ;,#[], it's punctuation. Leave it alone.
		tokenName = "Punctuation";
		lexeme = sym;
		sym = nextSym();
	}else if(sym == "+" || sym == "*" || sym == "-" || sym == "/" || sym == "\%"){		//If we're looking at +*-/%, it's an arithmetic operator.
		tokenName = "ArithOperator";
		lexeme = sym;
		sym = nextSym();
	}else if(sym == "<"){						//If it's "<", we need to see if it's <, <=, or <>
		sym = nextSym();
		if(sym == ">"){
			lexeme = "<>";
			tokenName = "Not equal";
			sym = nextSym();
		}else if(sym == "="){
			tokenName = "Less than or Equal";
			lexeme = "<=";
			sym = nextSym();
		}else{
			tokenName = "Less than";
			lexeme = "<";
		}
	}else if(sym == ">"){					//Otherwise, if it's ">" we just need to check > and >=
		sym = nextSym();
		if(sym == "="){
			tokenName = "Greater than or Equal";
			lexeme = ">=";
			sym = nextSym();
		}else{
			tokenName = "Greater than";
			lexeme = ">";
		}
	}
	return token(n, tokenName, lexeme);
}


std::string nextSym(){
	//char chr = tolower(std::cin.get());
	char chr = std::cin.get();
	std::string s = std::string(1, chr);
	return s;
}
