#include "../../scanner/scanner.h"
#include "stdlib.h"
#include<stack>
#include<iomanip>
#include<vector>
#include<sstream>
using namespace std;
//Set up scanner
token tok(0, "", "");



/*
*
*	STRUCT DEFINITIONS
*
*/

struct Variable{
	string kName;
	string aName;
	string type;
	int scope;
	int offset;
};

struct Literal{
	string name;
	string value;
	string type;
};

struct GoToLabel{
	string kName;
	string aName;
	bool declared;
};

struct Argument{
	string type;
	string name;
	bool callBy;
};

struct Procedure{
	string name;
	vector<Argument> args;
	string returnType;
	string entryLabel;
	string exitLabel;
};

/*
*
*	END STRUCT DEFINITIONS
*
*/

/*
*
* 	FUNCTION DECLARATIONS
*
*/

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
int dcl_definitions(int scope);
int dcl_list(int scope);
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
bool match_token(string a, string b);
void error();
void addLine(string label, string opcode, string operands, string comment);
string generateLabel();
void printIntro();
void printOutro();
void swapTopOfStack();
void convertTopOfStackToFloat();
void printNewLine();
Variable getVariable(string kName);
void addAssign(string typeTwo, Variable var);
string appendString(string str, int n);
string getOffsetString(int offset);
Procedure findProc(string name);
void convertIntToReal();
void processArgs(Procedure proc);
void loadArgsToLocalVariables(Procedure proc);
void removeArgsFromStack(Procedure proc);
/*
*
*	END FUNCTION DECLARATIONS
*
*/






/*
*
*	CONSTANT DECLARATIONS
*
*/
string currentProc = "main";
string const REAL = "real";
string const INT = "int";
string const BOOL = "bool";
string const STRING = "string";
string const NONE = "";
int const LOCAL = 0;
int const GLOBAL = 1;
int const CONST = 2;
const int FOUND = 1;
const int DOES_NOT_MATCH = 0;
const int FAILED = -1;
int storage = 0;
//vector<Identifier> globalIdentifiers;

vector<Variable> globalVars;
vector<Variable> localVars;
vector<Variable> constants;

stack<string> typeStack;
vector<Literal> literals;
vector<GoToLabel> gotos;
vector<Procedure> procs;

/*
*
*	END CONSTANT DECLARATIONS
*
*/

void error(){
	cerr << "Error on line " << tok.lineNumber << endl;
	cerr << tok.lineNumber - 1 << ": " << lineOne;
	if(tok.lineNumber == 0){
		cerr << endl;
	}
	cerr << tok.lineNumber << ": " << lineTwo << endl;
	cerr << "Unexpected token: " << tok.lexeme << endl;
	exit(EXIT_FAILURE);
}

bool match_token(string a, string b){
	if(a == b){
		tok = getNext();
		return true;
	}
	return false;
}

int main(){
	sym = nextSym();
	tok = getNext();
	Procedure proc;
	proc.name = "main";
	proc.entryLabel = "Entry_" + proc.name;
	proc.exitLabel = "Exit_" + proc.name;
	procs.push_back(proc);
	printIntro();
	klump_program();
	printOutro();
}

//<klump_program> -> <global_definitions><procedure_list>.
int klump_program(){
	if(global_definitions() == FOUND){
		if(procedure_list() == FOUND){
			if(match_token(tok.lexeme, ".")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<global_definitions> -> GLOBAL <const_definitions> <type_definitons> <dcl_definitions> <proc_declarations> | ""
int global_definitions(){
	if(match_token(tok.lexeme, "global")){
		if(const_definitions() == FOUND && type_definitions() == FOUND && dcl_definitions(GLOBAL) == FOUND && proc_declarations() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

//<const_definitions> -> CONST <const_list> | ""
int const_definitions(){
	if(match_token(tok.lexeme, "const")){
		if(const_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}


int const_list(){
	token t = tok;
	bool pass = false;;
	//Identifier : _const;
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")){
			if(_const() == FOUND){
				Variable id;
				id.scope = CONST;
				id.kName = t.lexeme;
				id.aName = "_" + t.lexeme + "_";
				if(typeStack.top() == INT){
					id.type = INT;
					addLine("", "pop", "dword [" + id.aName + "]", "Assign int value to const variable");
				}else if(typeStack.top() == STRING){
					id.type = STRING;
					addLine("", "pop", "dword [" + id.aName + "]", "Assign string address to const variable");
				}else if(typeStack.top() == REAL){
					id.type = REAL;
					addLine("", "pop", "dword [" + id.aName + "]", "Assign first half of real to const variable");
					addLine("", "pop", "dword [" + id.aName + " + 4]", "");
				}
				typeStack.pop();
				constants.push_back(id);
				if(match_token(tok.lexeme, ";")){
					t = tok;
					pass = true;
				}
			}
		}

		if(pass){
			pass = false;
		}else{
			error();
		}

	}
	return FOUND;
}


int _const(){
	token t = tok;
	if(match_token(tok.tokenName, "number") || match_token(tok.tokenName, "decimal") || match_token(tok.tokenName, "cstring")){
		if(t.tokenName == "number"){
			addLine("", "push", t.lexeme, "Push int literal to stack");
			typeStack.push(INT);
		}else if(t.tokenName == "cstring"){
			Literal l;
			l.name = generateLabel();
			l.value = t.lexeme + ", 0";
			l.type = STRING;
			literals.push_back(l);
			addLine("", "push", l.name, "Push address of string literal to stack");
			typeStack.push(STRING);
		}else if(t.tokenName == "decimal"){
			Literal l;
			l.name = generateLabel();
			l.value = t.lexeme;
			l.type = REAL;
			literals.push_back(l);
			addLine("", "push", "dword [" + l.name + " + 4]", "Push value of real literal to stack in two parts");
			addLine("", "push", "dword [" + l.name + "]", "");
			typeStack.push(REAL);
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

int type_definitions(){
	if(match_token(tok.lexeme, "type")){
		if(type_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int type_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& struct_type() == FOUND
			&& match_token(tok.lexeme, ";")){

			}else{
				error();
			}
	}
	return FOUND;
}


int struct_type(){
	if(array_type() == DOES_NOT_MATCH){
		return record_type();
	}

	return FOUND;
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
			error();
		}
	}
	return DOES_NOT_MATCH;
}


int record_type(){
	if(match_token(tok.lexeme, "record")){
		if(fld_list() == FOUND && match_token(tok.lexeme, "end")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}


int fld_list(){
	while(match_token(tok.tokenName, "Identifier")){
		if(match_token(tok.lexeme, ":")
			&& dcl_type() == FOUND
			&& match_token(tok.lexeme, ";")){

			}else{
				error();
			}
	}
	return FOUND;
}

int dcl_definitions(int scope){
	if(match_token(tok.lexeme, "dcl")){
		if(dcl_list(scope) == FOUND){
			return FOUND;
		}else{
			error();
		}
	}
	return FOUND;
}


int dcl_list(int scope){
	bool pass = false;
	token t1 = tok;
	while(match_token(tok.tokenName, "Identifier")){
		//Identifier : type;
		//:dcl_type();
		if(match_token(tok.lexeme, ":")){
			//bool, int, real, string, or identifier
			token  t2 = tok;
			if(dcl_type() == FOUND){
				Variable id;
				id.kName = t1.lexeme;
				if(scope == GLOBAL){
					id.scope = GLOBAL;
					id.aName = "_" + id.kName + "_";
				}else if(scope == LOCAL){
					id.scope = LOCAL;
				}
				if(t2.lexeme == "bool"){
					id.type = BOOL;
					id.offset = storage + 4;
				}else if(t2.lexeme == "real"){
					id.type = REAL;
					id.offset = storage + 8;
				}else if(t2.lexeme == "int"){
					id.type = INT;
					id.offset = storage + 4;
				}else{
					id.type = t2.lexeme;
				}
				storage = id.offset;

				if(id.scope == LOCAL){
					localVars.push_back(id);
				}else if(id.scope == GLOBAL){
					globalVars.push_back(id);
				}
				if(match_token(tok.lexeme, ";")){
					pass = true;
				}
			}
		}

		if(pass){
			pass = false;
		}else{
			error();
		}
		t1 = tok;
	}

	return FOUND;
}

int dcl_type(){
	if(atomic_type() == FOUND){
		return FOUND;
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
		|| match_token(tok.lexeme, "int") || match_token(tok.lexeme, "string")){
			return FOUND;
		}
	return DOES_NOT_MATCH;
}

int proc_declarations(){
	if(match_token(tok.lexeme, "proc")){
		if(signature_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int signature_list(){
	if(proc_signature() == FOUND){
		while(match_token(tok.lexeme, ";")){
			if(proc_signature() == FOUND){

			}else{

				return FOUND;
			}
		}

	}
	return FOUND;
}

int proc_signature(){
	string name = tok.lexeme;
	Procedure proc;
	vector<Argument> args;
	proc.entryLabel = "Entry_" + name;
	proc.exitLabel = "Exit_" + name;
	if(match_token(tok.tokenName, "Identifier")){
		proc.name = name;
		if(match_token(tok.lexeme, "(")){
			bool callBy = false;
			if(match_token(tok.lexeme, "var")){
				callBy = true;
			}
			string argName = tok.lexeme;
			while(match_token(tok.tokenName, "Identifier")){
				Argument arg;
				arg.name = argName;
				arg.callBy = callBy;
				if(match_token(tok.lexeme, ":")){
					string type;
					if(match_token(tok.lexeme, "real")){
						arg.type = REAL;
					}else if(match_token(tok.lexeme, "bool")){
						arg.type = BOOL;
					}else if(match_token(tok.lexeme, "int")){
						arg.type = INT;
					}else if(match_token(tok.lexeme, "string")){
						arg.type = STRING;
					}else if(match_token(tok.tokenName, "Identifier")){
						arg.type = type;
					}
					args.push_back(arg);

					if(!match_token(tok.lexeme, ",")){
						if(match_token(tok.lexeme, ")")){
							if(match_token(tok.lexeme, ":")){
								string returnType;
								if(match_token(tok.lexeme, "real")){
									returnType = REAL;
								}else if(match_token(tok.lexeme, "bool")){
									returnType = BOOL;
								}else if(match_token(tok.lexeme, "int")){
									returnType = INT;
								}else if(match_token(tok.lexeme, "string")){
								  	returnType = STRING;
								}
								proc.returnType = returnType;
								proc.args = args;
								procs.push_back(proc);
								return FOUND;
							}else{
								proc.args = args;
								proc.returnType = NONE;
								procs.push_back(proc);
								return FOUND;
							}
						}else{
							error();
						}
					}

				}else{
					error();
				}

				if(match_token(tok.lexeme, "var")){
					callBy = true;
				}else{
					callBy = false;
				}
				argName = tok.lexeme;
			}
			if(match_token(tok.lexeme, ")")){
				if(match_token(tok.lexeme, ":")){
					string returnType = tok.lexeme;
					if(match_token(tok.lexeme, "real")){
						returnType = REAL;
					}else if(match_token(tok.lexeme, "bool")){
						returnType = BOOL;
					}else if(match_token(tok.lexeme, "int")){
						returnType = INT;
					}else if(match_token(tok.lexeme, "string")){
						returnType = STRING;
					}
					proc.returnType = returnType;
					proc.args = args;
					procs.push_back(proc);
					return FOUND;
				}
				proc.returnType = NONE;
				procs.push_back(proc);
				return FOUND;
			}else{
				error();
			}
		}else{
			error();
		}
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
		error();

	}
	return FOUND;
}

int formal_arg_list(){

	if(formal_arg() == FOUND){
		while(match_token(tok.lexeme, ",")){
			if(formal_arg() == FOUND){

			}else{
				error();
			}
		}
		return FOUND;
	}
	return FOUND;

}

int formal_arg(){
	if(call_by() == FOUND){
		if(match_token(tok.tokenName, "Identifier") && match_token(tok.lexeme, ":") && dcl_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int call_by(){
	if(match_token(tok.lexeme, "var")){
		return FOUND;
	}

	return FOUND;
}

int return_type(){
	if(match_token(tok.lexeme, ":")){
		if(atomic_type() == FOUND){
			return FOUND;
		}
		error();
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
		error();
	}
	return DOES_NOT_MATCH;
}

int actual_arg_list(){
	if(actual_arg() == FOUND){
		while(match_token(tok.lexeme, ",") ){
			if(actual_arg() == FOUND){
			}else{
				error();
			}
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;

}

int actual_arg(){
	return expression();
}

int procedure_list(){
	while(procedure() == FOUND){
		localVars.clear();
		gotos.clear();
	}
	return FOUND;
}

int procedure(){
	storage = 0;


	if(proc_head() == FOUND){
		if(proc_body() == FOUND){
			for(int i = 0; i < gotos.size(); i++){
				if(!gotos.at(i).declared){
					cerr << "Label: " << gotos.at(i).kName << " undeclared" << endl;
					error();
				}
			}
			Procedure proc = findProc(currentProc);
			addLine(proc.exitLabel, "", "", "");
			addLine("", "mov", "esp, ebp", "");
			addLine("", "pop", "ebp", "");
			addLine("", "ret", "", "Return control to calling function");
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int proc_head(){
	if(match_token(tok.lexeme, "procedure")){
		string name = tok.lexeme;
		if(match_token(tok.tokenName, "Identifier")){
			currentProc = name;
			Procedure proc = findProc(currentProc);
			loadArgsToLocalVariables(proc);
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int proc_body(){
	if(dcl_definitions(LOCAL) == FOUND){
		addLine("Entry_" + currentProc, "", "", "");
		addLine("", "push", "ebp", "Store base pointer");
		addLine("", "mov", "ebp, esp", "Create new base pointer");
		addLine("", "sub", appendString("esp, ", storage),  "");
		if(match_token(tok.lexeme, "begin")){
			if(statement_list() == FOUND){
				if(match_token(tok.lexeme, "end")){
					return FOUND;
				}
			}
		}
		error();
		}
	return DOES_NOT_MATCH;
}
int statement_list(){
	while(statement() == FOUND){

	}
	return FOUND;
}
int statement(){
	if(label() == FOUND){
		if(exec_statement() == FOUND){
			return FOUND;
		}
		return DOES_NOT_MATCH;
	}
	return DOES_NOT_MATCH;
}
int label(){
	if(match_token(tok.lexeme, "#")){
		string label = "#" + tok.lexeme;
		if(match_token(tok.tokenName, "number")){
			bool found = false;
			for(int i = 0; i < gotos.size(); i++){
				if(gotos.at(i).kName == label){
					found = true;
					if(gotos.at(i).declared){
						cerr << "Duplicate goto" << endl;
						error();
					}else{
						gotos.at(i).declared = true;
					}
				}
			}
			if(!found){
				GoToLabel gtl;
				gtl.kName = label;
				gtl.aName = "_" + label + "_";
				gtl.declared = true;
				gotos.push_back(gtl);
			}
			addLine("_" + label + "_", "", "", "");
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int exec_statement(){

	int result = read_statement();
	if(result == FOUND){
		return result;
	}

	result = write_statement();
	if(result == FOUND){
		return result;
	}
	result = assign_statement();
	if(result == FOUND){
		return result;
	}
	result = call_statement();
	if(result == FOUND){
		return result;
	}

	result = return_statement();
	if(result == FOUND){
		return result;
	}

	result = goto_statement();
	if(result == FOUND){
		return result;
	}

	result = empty_statement();
	if(result == FOUND){
		return result;
	}

	result = compound_statement();
	if(result == FOUND){
		return result;
	}

	result = if_statement();
	if(result == FOUND){
		return result;
	}

	result = while_statement();
	if(result == FOUND){
		return result;
	}

	result = case_statement();
	if(result == FOUND){
		return result;
	}
	result = for_statement();
	if(result == FOUND){
		return result;
	}
	result = next_statement();
	if(result == FOUND){
		return result;
	}


	result = break_statement();
	if(result == FOUND){
		return result;
	}
	return DOES_NOT_MATCH;
}


int read_statement(){
	string call = tok.lexeme;
	if(match_token(tok.lexeme, "read") || match_token(tok.lexeme, "readln")){
		if(match_token(tok.lexeme, "(")){
			string id = tok.lexeme;
			while(match_token(tok.tokenName, "Identifier")){
				Variable idToWrite;
				idToWrite = getVariable(id);
				if(idToWrite.scope == GLOBAL){
					addLine("", "push", idToWrite.aName, "Push address to input variable");
				}else if(idToWrite.scope == LOCAL){
					addLine("", "mov", "eax, ebp", "");
					addLine("", "sub", appendString("eax, ", idToWrite.offset), "Subtract offset from ebp to find address of input variable");
					addLine("", "push", "eax", "");
				}
				if(idToWrite.type == INT){
					addLine("", "push", "intFrmtIn", "");
				}else if(idToWrite.type == REAL){
					addLine("", "push", "realFrmtIn", "");
				}else if(idToWrite.type == STRING){
					addLine("", "push", "stringFrmtIn", "");
				}else{
					cerr << "Cannot input type" << idToWrite.type << endl;
					error();
				}

				addLine("", "call", "scanf", "Retrieve input from user");
				addLine("", "add", "esp, 8", "Remove arguments from stack");

				if(!match_token(tok.lexeme, ",")){
					if(match_token(tok.lexeme, ")")){
						if(match_token(tok.lexeme, ";")){
							if(call == "readln"){
								string label = generateLabel();
								addLine(label, "call", "getchar", "Remove characters until \\n");
								addLine("", "cmp", "eax, 0xA", "");
								addLine("", "jne", label, "If the character isn't \\n, continue removing");
							}
							return FOUND;
						}
					}
					error();
				}

				id = tok.lexeme;
			}


		}
	}
	return DOES_NOT_MATCH;
}

int write_statement(){
	string call = tok.lexeme;
	if(match_token(tok.lexeme, "write") || match_token(tok.lexeme, "writeln")){
		if(match_token(tok.lexeme, "(")){
			while(expression() == FOUND){
				if(typeStack.top() == REAL){
					addLine("", "push", "realFrmt", "Push format string for printf");
					addLine("", "call", "printf", "");
					addLine("", "add", "esp, 12", "");
				}else{
					if(typeStack.top() == INT || typeStack.top() == BOOL){
						addLine("", "push", "intFrmt", "Push format string for printf");
					}else if(typeStack.top() == STRING){
						addLine("", "push", "stringFrmt", "Push format string for printf");
					}
					addLine("", "call", "printf", "");
					addLine("", "add", "esp, 8", "");
				}

				typeStack.pop();
				if(!match_token(tok.lexeme, ",")){
					if(match_token(tok.lexeme, ")")){
						if(match_token(tok.lexeme, ";")){
							if(call == "writeln"){
								printNewLine();
							}
							return FOUND;
						}
					}
					error();
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}


int assign_statement(){
	token t = tok;
	if(match_token(tok.tokenName, "Identifier")){
		/* Have we seen this identifier declared? */
		Variable id  = getVariable(t.lexeme);

		if(qualifier() == FOUND){								//Are we dealing with an Array/Record?
			if(match_token(tok.lexeme, ":=")){
				if(expression() == FOUND){						//Find an expression and push it to the stack
					string typeTwo = typeStack.top();
					typeStack.pop();
					addAssign(typeTwo, id);
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int call_statement(){
	if(match_token(tok.lexeme, "call")){
		string name = tok.lexeme;
		if(match_token(tok.tokenName, "Identifier")){
			Procedure proc = findProc(name);
			if(match_token(tok.lexeme, "(")){
				//Process args
				processArgs(proc);
				if(match_token(tok.lexeme, ")")){
					addLine("", "call", proc.entryLabel, "");
					removeArgsFromStack(proc);
					//Remove args from stack
					return FOUND;
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int return_statement(){
	if(match_token(tok.lexeme, "return")){

			if(expression() == FOUND){
					Procedure proc = findProc(currentProc);
					if(proc.returnType == REAL){
						if(typeStack.top() == REAL){
							addLine("", "movsd", "xmm0, [esp]", "Move return value to xmm0");
							addLine("", "add", "esp, 8", "");
						}else if(typeStack.top() == INT){
							addLine("", "fild", "dword [esp]", "");
							addLine("", "fstp", "qword xmm0", "Move return value to xmm0");
						}else{
							cerr << "Invalid return type" << endl;
							error();
						}
					}else{
						addLine("", "pop", "eax", "Move return value to eax");
					}
                    addLine("", "jmp", proc.exitLabel, "Jump to function exit");
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}

			}

		error();
	}
	return DOES_NOT_MATCH;
}

int goto_statement(){
	if(match_token(tok.lexeme, "goto")){
		if(match_token(tok.lexeme, "#")){
			string label = "#" + tok.lexeme;
			if(match_token(tok.tokenName, "number")){
				bool found = false;
				for(int i = 0; i < gotos.size(); i++){
					if(gotos.at(i).kName == label){
						found = true;
					}
				}
				if(!found){
					GoToLabel gtl;
					gtl.kName = label;
					gtl.aName = "_" + gtl.kName + "_";
					gtl.declared = false;
					gotos.push_back(gtl);
				}
				addLine("", "jmp", "_" + label + "_", "");
				if(match_token(tok.lexeme, ";")){
					return FOUND;
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int empty_statement(){
	if(match_token(tok.lexeme, ";")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}
int compound_statement(){
	if(match_token(tok.lexeme, "do")){
		if(match_token(tok.lexeme, ";")){
			if(statement_list() == FOUND){
				if(match_token(tok.lexeme, "end")){
					if(match_token(tok.lexeme, ";")){
						return FOUND;
					}
				}
			}
		}
		error();
	}

	return DOES_NOT_MATCH;
}


int if_statement(){
	if(match_token(tok.lexeme, "if")){
		if(match_token(tok.lexeme, "(")){
			if(comparison() == FOUND){
				if(match_token(tok.lexeme, ")")){
					if(match_token(tok.lexeme, "then")){
						if(typeStack.top() != BOOL){
							cerr << "Non-boolean expression found: " << typeStack.top() << endl;
							error();
						}
						typeStack.pop();
						addLine("", "pop", "eax", "Remove bool from stack");
						string iffalse = generateLabel();
						string end = generateLabel();
						addLine("", "mov", "ebx, 0", "");
						addLine("", "cmp", "eax, ebx", "Compare bool to 0");
						addLine("", "je", iffalse, "If bool is 0, jump to the else clause");
						if(statement() == FOUND){
							addLine("", "jmp", end, "Skip the else clause");
							addLine(iffalse, "", "", "Beginning of else clause");
							if(else_clause() == FOUND){
								addLine(end, "", "", "End of else clause");
								return FOUND;
							}
						}

					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int else_clause(){
	if(match_token(tok.lexeme, "else")){
		if(statement() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

int while_statement(){
	if(match_token(tok.lexeme, "while")){
		if(match_token(tok.lexeme, "(")){
			string headOfWhileLoop = generateLabel();
			string endOfWhileLoop = generateLabel();
			addLine(headOfWhileLoop, "", "", "Start of while loop");
			if(comparison() == FOUND){
				if(typeStack.top() != BOOL){
					cerr << "Non-boolean expression found: " << typeStack.top() << endl;
					error();
				}
				typeStack.pop();
				addLine("", "pop", "eax", "Remove bool to test while condition");
				addLine("", "mov", "ebx, 1", "");
				addLine("", "cmp", "eax, ebx", "See if while condition is true");
				addLine("", "jne", endOfWhileLoop, "If comparison is false, jump to end");
				if(match_token(tok.lexeme, ")")){
					if(compound_statement() == FOUND){
						addLine("", "jmp", headOfWhileLoop, "Jump back to the top of while loop");
						addLine(endOfWhileLoop, "", "", "Destination if while condition fails");
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int case_statement(){
	if(match_token(tok.lexeme, "case")){
		if(match_token(tok.lexeme, "(")){
			if(expression() == FOUND){
				if(match_token(tok.lexeme, ")")){
					if(case_list() == FOUND){
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int case_list(){
	bool pass = false;
	bool firstpass = false;
	while(unary() == FOUND){
		firstpass = true;
		if(match_token(tok.tokenName, "number")){
			if(match_token(tok.lexeme, ":")){
				if(statement() == FOUND){
					pass = true;
				}
			}
		}
		if(pass){
			pass = !pass;
		}else{
			error();
		}

	}

	if(match_token(tok.lexeme, "default")){
		if(match_token(tok.lexeme, ":")){
			if(statement() == FOUND){
				return FOUND;
			}
		}
		error();
	}
	if(firstpass){
		error();
	}
	return DOES_NOT_MATCH;

}

int for_statement(){
	if(match_token(tok.lexeme, "for")){
		if(match_token(tok.tokenName, "Identifier")){
			if(match_token(tok.lexeme, ":=")){
				if(expression() == FOUND){
					if(match_token(tok.lexeme, "to") || match_token(tok.lexeme, "downto")){
						if(expression() == FOUND){
							if(statement() == FOUND){
								return FOUND;
							}
						}
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int next_statement(){
	if(match_token(tok.lexeme, "next")){
		if(match_token(tok.lexeme, ";")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int break_statement(){
	if(match_token(tok.lexeme, "break")){
		if(match_token(tok.lexeme, ";")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int expression(){
	return comparison();
}

int comparison(){
	if(simple_expression() == FOUND){
		string comparison = tok.lexeme;
		while(compop() == FOUND){
			if(simple_expression() == FOUND){
					string typeTwo = typeStack.top();
					typeStack.pop();
					string typeOne = typeStack.top();
					typeStack.pop();
					string iftrue = generateLabel();
					string end = generateLabel();
					string opCode;
					if(typeOne == INT && typeTwo == INT){
						addLine("", "pop", "ebx", "Remove operands from stack for comparison");
						addLine("", "pop", "eax", "");
						addLine("", "cmp", "eax, ebx", "");
						if(comparison == "="){
							opCode = "je";
						}else if(comparison == "<>"){
							opCode = "jne";
						}else if(comparison == ">"){
							opCode = "jg";
						}else if(comparison == ">="){
							opCode = "jge";
						}else if(comparison == "<"){
							opCode = "jl";
						}else if(comparison == "<="){
							opCode = "jle";
						}
						addLine("", opCode, iftrue, "Push appropriate bool if based on comparison");
					}else if ((typeOne == INT || typeOne == REAL) && (typeTwo == INT || typeTwo == REAL)){
						if(typeOne == INT){
							addLine("", "sub", "esp, 4", "Make room on stack to convert int to real");
							addLine("", "mov", "eax, [esp + 4]", "Move real to new stack location in two parts");
							addLine("", "mov", "[esp], eax", "");
							addLine("", "mov", "eax, [esp + 8]", "Move to eax first because mov doesn't accept two memory locations");
							addLine("", "mov", "[esp + 4], eax", "");
							addLine("", "fild", "dword [esp + 12]", "Load int to floating point stack for conversion");
							addLine("", "fstp", "qword [esp + 8]", "Put new float back on stack");

						}else if(typeTwo == INT){
							addLine("", "sub", "esp, 4", "Make room on stack to convert int to real");
							addLine("", "fild", "[esp + 4]", "Load int to floating point stack");
							addLine("", "fstp", "qword [esp]", "Put new float back on stack");
						}
						/*
							Compare two floating points on top of stack
						*/
						addLine("", "movsd", "xmm1, [esp]", "");
						addLine("", "movsd", "xmm0, [esp + 8]", "");
						addLine("", "add", "esp, 8", "");
						if(comparison == "="){
							opCode = "0";
						}else if(comparison == "<>"){
							opCode = "4";
						}else if(comparison == ">"){
							opCode = "6";
						}else if(comparison == ">="){
							opCode = "5";
						}else if(comparison == "<"){
							opCode = "1";
						}else if(comparison == "<="){
							opCode = "2";
						}

						addLine("", "cmpsd", "xmm0, xmm1, " + opCode, "Compare floating point");
						addLine("", "movsd", "[esp], xmm0", "Put result on stack");
						addLine("", "add", "esp, 4", "Throw away half of result");
						addLine("", "pop", "eax", "");
						addLine("", "cmp", "eax, 0", "Was the results 0's or 1's?");
						addLine("", "jne", iftrue, "If it wasn't 0, jump to push 1");
					}else{
						cerr << "Unsupported operand for " << comparison << endl;
						error();
					}



					addLine("", "push", "0", "Push 0 for false comparison");
					addLine("", "jmp", end, "Skip pushing 1");
					addLine(iftrue, "", "", "Label if comparison was true");
					addLine("", "push", "1", "Push 1 for true comparison");
					addLine(end, "", "", "End of comparison");
					typeStack.push(BOOL);
			}else{
				error();
			}
		}
		return FOUND;
	}


	return DOES_NOT_MATCH;

}

int simple_expression(){
	bool pass = false;
	string un = tok.lexeme;
	if(unary() == FOUND){
		if(term() == FOUND){
			if(un == "-"){
				if(typeStack.top() == INT){
					addLine("", "pop", "eax", "Pop top of stack to negate");
					addLine("", "neg", "eax", "");
					addLine("", "push", "eax", "Push negated term to stack");
				}else if(typeStack.top() == REAL){
					addLine("", "movsd", "xmm0, [esp]", "Move stack to xmm0 to negate");
					addLine("", "movsd", "xmm1, [negone]", "");
					addLine("", "mulsd", "xmm0, xmm1", "Multiply by -1 to negate");
					addLine("", "movsd", "[esp], xmm0", "Push negated float back to stack");
				}
			}
			string op = tok.lexeme;
			while(addop() == FOUND){
				if(term() == FOUND){
					string typeTwo = typeStack.top();
					typeStack.pop();
					string typeOne = typeStack.top();
					typeStack.pop();

					if(typeOne == INT && typeTwo == INT){
						addLine("", "pop", "ebx", "Remove operands from stack to addop");
						addLine("", "pop", "eax", "");
						if(op == "+"){
							addLine("", "add", "eax, ebx", "Add operands");
							typeStack.push(INT);
						}else if(op == "-"){
							addLine("", "sub", "eax, ebx", "Subtract operands");
							typeStack.push(INT);
						}
						addLine("", "push", "eax", "Push result to stack");
					}else{
						bool swapped = false;
						if(typeOne == INT && typeTwo == REAL){
							swapped = true;
							swapTopOfStack();
							typeOne = REAL;
							typeTwo = INT;
						}
						if(typeTwo == INT){
							convertTopOfStackToFloat();
						}

						/* Add or subtract floats on top of stack */
						addLine("", "movsd", "xmm1, [esp]", "Put top of stack into floating point registers");
						addLine("", "movsd", "xmm0, [esp + 8]", "");
						addLine("", "add", "esp, 8", "Remove extra space from stack");
						if(op == "+"){
							addLine("", "addsd", "xmm0, xmm1", "Add operands");
							typeStack.push(REAL);
						}else if(op == "-"){
							if(swapped){
								addLine("", "subsd", "xmm1, xmm0", "Subtract operands in reverse order because they were swapped");
								addLine("", "movsd", "xmm0, xmm1", "Move result to xmm0");
							}else{
								addLine("", "subsd", "xmm0, xmm1", "Subtract operands");
							}
							typeStack.push(REAL);
						}

						addLine("", "movsd", "[esp], xmm0", "Push result to top of stack");


					}


					pass = true;
				}else{
					error();
				}
			}
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

int term(){

	if(factor() == FOUND){
		string op = tok.lexeme;
		while(mulop() == FOUND){
			if(factor() == FOUND){
				string typeTwo = typeStack.top();
				typeStack.pop();
				string typeOne = typeStack.top();
				typeStack.pop();
				if(typeOne == INT && typeTwo == INT){
					addLine("", "pop", "ebx", "Remove operands from stack to mulop");
					addLine("", "pop", "eax", "");
					if(op == "*"){
						addLine("", "imul", "eax, ebx", "");
						typeStack.push(INT);

					}else if(op == "/"){
						addLine("", "cdq", "", "Sign extend eax");
						addLine("", "idiv", "ebx", "Divide operands");
						typeStack.push(INT);
					}else if(op == "%"){
                        addLine("", "cdq", "", "Sign extend eax");
                        addLine("", "idiv", "ebx", "Divide operands");
                        addLine("", "mov", "eax, edx", "Move modulo result to eax");
                        typeStack.push(INT);
                    }

					addLine("", "push", "eax", "Push result to stack");
				}else if(typeOne == BOOL && typeTwo == BOOL){
                    if(op == "and"){
                        addLine("", "pop", "ebx", "Pop operands from stack");
                        addLine("", "pop", "eax", "");
                        addLine("", "and", "eax, ebx", "Complete comparison");
                        addLine("", "push", "eax", "Push result to stack");
                        typeStack.push(BOOL);
                    }else{
                        error();
                    }
                }else{
					bool swapped = false;
					if(typeOne == INT && typeTwo == REAL){
						swapped = true;
						swapTopOfStack();
						typeTwo = INT;
						typeOne = REAL;
					}
					if(typeTwo == INT){
						convertTopOfStackToFloat();
					}

					addLine("", "movsd", "xmm1, [esp]", "Remove operands from stack to mulop");
					addLine("", "movsd", "xmm0, [esp + 8]", "");
					addLine("", "add", "esp, 8", "Remove extra space from stack");
					if(op == "*"){
						addLine("", "mulsd", "xmm0, xmm1", "Multiply floating point operands");
						typeStack.push(REAL);
					}else if(op == "/"){
						if(swapped){
							addLine("", "divsd", "xmm1, xmm0", "Divide in reverse order");
							addLine("", "movsd", "xmm0, xmm1", "Move result to xmm0");
						}else{
							addLine("", "divsd", "xmm0, xmm1", "Divide floating point operands");
						}
						typeStack.push(REAL);
					}
					addLine("", "movsd", "[esp], xmm0", "Push result to stack");
				}
			}else{
				error();
			}
		}
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

int factor(){
	int result;
	result = _const();
	if(result == FOUND || result == FAILED){
		return result;
	}
	if(match_token(tok.lexeme, "(")){
		if(expression() == FOUND){
			if(match_token(tok.lexeme, ")")){
				return FOUND;
			}
		}
		error();
	}

	if(match_token(tok.lexeme, "not")){
		if(factor() == FOUND){
			return FOUND;
		}
		error();
	}


	/* Lval or fun_ref? */
	/* First token is an Identifier...*/
	string id = tok.lexeme;
	if(match_token(tok.tokenName, "Identifier")){
		/*If it's followed by a qualifier, we have an lval*/
		string next = tok.lexeme;
		if(match_token(tok.lexeme, "(")){
			Procedure proc = findProc(id);
			processArgs(proc);
			if(match_token(tok.lexeme, ")")){
				addLine("", "call", proc.entryLabel, "");
				removeArgsFromStack(proc);
				if(proc.returnType == REAL){
					addLine("", "sub", "esp, 8", "");
					addLine("", "movsd", "[esp], xmm0", "Push return value to stack");
				}else{
					addLine("", "push", "eax", "Push return value to stack");
				}
				typeStack.push(proc.returnType);
				return FOUND;
			}
			error();
		}else if(qualifier() == FOUND){
			if(next != "." && next != "["){
				Variable found = getVariable(id);
				typeStack.push(found.type);
				if(found.type == REAL){
					if(found.scope == GLOBAL || found.scope == CONST){
						addLine("", "push", "dword [" + found.aName + " + 4]", "Push global real to stack in two parts");
						addLine("", "push", "dword [" + found.aName + "]", "");
					}else{
						addLine("", "push", "dword " + getOffsetString(found.offset - 4), "Push local real to stack in two parts");
						addLine("", "push", "dword " + getOffsetString(found.offset), "");
					}
				}else{
					if(found.scope == GLOBAL || found.scope == CONST){
						addLine("", "push", "dword [" + found.aName + "]", "Push global var to stack");
					}else{
						addLine("", "push", "dword " + getOffsetString(found.offset), "Push local var to stack");
					}
				}
			}
			return FOUND;
		}


	}

	return DOES_NOT_MATCH;
}


int compop(){
	if(match_token(tok.lexeme, "=")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<>")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<")){
		return FOUND;
	}else if(match_token(tok.lexeme, ">")){
		return FOUND;
	}else if(match_token(tok.lexeme, ">=")){
		return FOUND;
	}else if(match_token(tok.lexeme, "<=")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int addop(){
	if(match_token(tok.lexeme, "+")){
		return FOUND;
	}else if(match_token(tok.lexeme, "-")){
		return FOUND;
	}else if(match_token(tok.lexeme, "or")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int mulop(){
	if(match_token(tok.lexeme, "*")){
		return FOUND;
	}else if(match_token(tok.lexeme, "/")){
		return FOUND;
	}else if(match_token(tok.lexeme, "%")){
		return FOUND;
	}else if(match_token(tok.lexeme, "and")){
		return FOUND;
	}

	return DOES_NOT_MATCH;
}

int unary(){
	if(match_token(tok.lexeme, "+")){
		return FOUND;
	}else if(match_token(tok.lexeme, "-")){
		return FOUND;
	}else{
		return FOUND;
	}
}


int qualifier(){
	if(match_token(tok.lexeme, "[")){
		if(expression() == FOUND){
			if(match_token(tok.lexeme, "]")){
				if(qualifier() == FOUND){
					return FOUND;
				}
			}
		}
		error();
	}

	if(match_token(tok.lexeme, ".")){
		if(match_token(tok.tokenName, "Identifier")){
			if(qualifier() == FOUND){
				return FOUND;
			}
		}
		error();
	}

	return FOUND;
}


void addLine(string label, string opcode, string operands, string comment){
  if (label != "")
	 cout << setw(15) << left << label + ":";
  else
	 cout << setw(15) << left << " ";
  if (opcode != "")
	 cout << setw(10) << left << opcode;
  else
	 cout << setw(10) << left << " ";
  if (operands != "")
	 cout << setw(20) << left << operands;
  else
	 cout << setw(20) << left << " ";
  if (comment != "")
	 cout << "\t" << ";" <<  comment;
  cout << endl;
}



string generateLabel(){
	static int k = 0;
	stringstream ss;
	ss << "Label" << k;
	string out;
	ss >> out;
	k++;
	return out;
}

string appendString(string str, int n){
	stringstream ss;
	ss << str << n;
	return ss.str();
}

string getOffsetString(int offset){
	stringstream ss;
	ss << "[ebp - " << offset << "]";
	return ss.str();
}
void printIntro(){
	addLine("", "global", "main", "");
	addLine("", "extern", "printf", "");
	addLine("", "extern", "scanf", "");
	addLine("", "extern", "getchar", "");
	addLine("", "section", ".text", "");
	addLine("main", "", "", "");
}
void printOutro(){
	addLine("", "", "", "");
	addLine("", "section", ".data", "");
	addLine("realFrmt", "db", "\"%f\", 0", "Print real without \\n");
	addLine("intFrmt", "db", "\"%d\", 0", "Print int without \\n");
	addLine("stringFrmt", "db", "\"%s\", 0", "Print string without \\n");
	addLine("realFrmtIn", "db", "\"%lf\", 0", "Read real");
	addLine("intFrmtIn", "db", "\"%i\", 0", "Read int");
	addLine("stringFrmtIn", "db", "\"%s\", 0", "Read string");
	addLine("NewLine", "db", "0xA, 0", "Print NewLine");

	addLine("negone", "dq", "-1.0", "Negative one");
	/*
		Print literals
	*/
	Literal l;
	for(int i = 0; i < literals.size(); i++){
		l = literals.at(i);
		string size;
		if(l.type == REAL){
			size = "dq";
		}else if(l.type == STRING){
			size = "db";
		}

		addLine(l.name, size, l.value, "");

	}
	addLine("", "", "", "");
	addLine("", "section", ".bss", "");
	for(int i = 0; i < globalVars.size(); i++){
		Variable id = globalVars.at(i);
		string size;
		if(id.type == REAL){
			size = "8";
		}else{
			size = "4";
		}
		addLine(id.aName, "resb(" + size + ")", "", "");
	};

	for(int i = 0; i < constants.size(); i++){
		Variable id = constants.at(i);
		string size;
		if(id.type == REAL){
			size = "8";
		}else{
			size = "4";
		}
		addLine(id.aName, "resb(" + size + ")", "", "");
	}


}


void swapTopOfStack(){
	addLine("", "movsd", "xmm0, [esp]", "Switch order of operands on stack");
	addLine("", "mov", "eax, [esp + 8]", "");
	addLine("", "movsd", "[esp + 4], xmm0", "");
	addLine("", "mov", "[esp], eax", "Finish pushing in reverse order");
}

void convertTopOfStackToFloat(){
	addLine("", "fild", "dword [esp]", "Convert int on stack to float");
	addLine("", "sub", "esp, 4", "Make room on stack for float");
	addLine("", "fstp", "qword [esp]", "Put new float on stack");
}

void printNewLine(){
	addLine("", "push", "NewLine", "Push newline to stack for printf");
	addLine("", "call", "printf", "");
	addLine("", "add", "esp, 4", "Clean up stack after printf");

}

void addAssign(string typeTwo, Variable var){
	if(var.type == REAL){
		if(typeTwo == INT){
			addLine("", "fild", "dword [esp]", "Load top of stack to floating point stack");
			addLine("", "sub", "esp, 4", "Make room on stack for 64-bit float");
			addLine("", "fstp", "qword [esp]", "Convert 32-bit int to 64-bit float");
		}
		if(var.scope == GLOBAL){
			addLine("", "pop", "dword [" + var.aName + "]", "Pop top of stack in two parts");
			addLine("", "pop", "dword [" + var.aName + "+ 4]", "");
		}else if(var.scope == LOCAL){
			addLine("", "lea", "esi, " + getOffsetString(var.offset), "Load address of local real");
			addLine("", "pop", "dword [esi]", "Store first half of real");
			addLine("", "lea", "esi, " + getOffsetString(var.offset - 4), "");
			addLine("", "pop", "dword [esi]", "");
		}
	}else if(var.type == INT){
		if(typeTwo == REAL){
			cerr << "Cannot convert float to int" << endl;
			error();
		}else if(typeTwo == INT){
			if(var.scope == GLOBAL){
				addLine("", "pop", "dword [" + var.aName + "]", "Pop top of stack to memory location");
			}else if(var.scope == LOCAL){
				addLine("", "lea", "esi, " + getOffsetString(var.offset), "Load address of local int");
				addLine("", "pop", "dword [esi]", "");
			}
		}
	}else if(var.type == STRING){
		addLine("", "pop", "dword [" + var.aName + "]", "Pop memory location of string to string variable");
	}
}


Variable getVariable(string kName){
	Variable found;
	for(int i = 0; i < localVars.size(); i++){
		if(localVars.at(i).kName == kName){
			return localVars.at(i);
		}
	}

	for(int i = 0; i < globalVars.size(); i++){
		if(globalVars.at(i).kName == kName){
			return globalVars.at(i);
		}
	}

	for(int i = 0; i < constants.size(); i++){
		if(constants.at(i).kName == kName){
			return constants.at(i);
		}
	}
	cerr << "Unknown identifier " << kName << endl;
	error();
	Variable v;
	return v;
}


Procedure findProc(string name){
	for(int i = 0; i < procs.size(); i++){

		if(procs.at(i).name == name){
			return procs.at(i);
		}
	}
	cerr << "Proc not found: " << name << endl;
	error();
	return procs.at(0);
}

void convertIntToReal(){
	addLine("", "fild", "[esp]", "Convert Int to Real");
	addLine("", "sub", "esp, 4", "");
	addLine("", "fstp", "qword [esp]", "Done converting int to real");
}

void processArgs(Procedure proc){
	vector<Argument> args = proc.args;

	for(int i = 0; i < args.size(); i++){

		Argument arg = args.at(i);
		if(arg.callBy){
		}else{
			if(expression() == FOUND){
				if(typeStack.top() == arg.type){

				}else if(typeStack.top() == INT && arg.type == REAL){
					convertIntToReal();
				}else{
					error();
				}
				if(!match_token(tok.lexeme, ",")){
					if(i != args.size() - 1){
						error();
					}
				}
			}else{
				error();
			}
		}
	}
}

void loadArgsToLocalVariables(Procedure proc){
	int offset = -8;
	vector<Argument> args = proc.args;
	for(int i = args.size() - 1; i >= 0; i--){
		Variable var;
		Argument arg = args.at(i);
		if(!arg.callBy){
			var.scope = LOCAL;
		}
		var.kName = arg.name;
		var.offset = offset;
		var.type = arg.type;
		if(arg.type == REAL){
			offset = offset - 8;
		}else{
			offset = offset - 4;
		}

		localVars.push_back(var);
	}

}

void removeArgsFromStack(Procedure proc){
	int size = 0;
	for(int i = 0; i < proc.args.size(); i++){
		if(proc.args.at(i).type == REAL){
			size += 8;
		}else{
			size += 4;
		}
	}
	addLine("", "add", appendString("esp, ", size), "Remove args from stack");
}
