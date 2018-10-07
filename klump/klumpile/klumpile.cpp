#include "../../scanner/scanner.cpp"
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


struct arrayType{
    string name;
    string type;
    int capacity;
    int storageUnit;
    int memReq;
};

struct namedInt{
    string name;
    int val;
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
int qualifier(arrayType type);
bool match_token(string a, string b);
void error();
void addLine(string label, string opcode, string operands, string comment);
string generateLabel();
void printIntro();
void printOutro();
void swapTopOfStack();
void convertTopOfStackToFloat();
void printNewLine();
void loadAddr(Variable var);
Variable getVariable(string kName);
void addAssign(string typeTwo, string typeOne);
string appendString(string str, int n);
string getOffsetString(int offset);
Procedure findProc(string name);
void convertIntToReal();
void processArgs(Procedure proc);
void loadArgsToLocalVariables(Procedure proc);
void removeArgsFromStack(Procedure proc);
string findTypeName();
arrayType getArrType(string name);
/*
*
*	END FUNCTION DECLARATIONS
*
*/




ofstream outFile;
string outFileName;
string execFileName;
bool keepAsm;

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
int const CALLBY = 3;
const int FOUND = 1;
const int DOES_NOT_MATCH = 0;
const int FAILED = -1;
int storage = 0;
//vector<Identifier> globalIdentifiers;

vector<Variable> globalVars;
vector<Variable> localVars;
vector<Variable> constants;
vector<namedInt> ints;

stack<string> typeStack;
stack<string> nextStack;
stack<string> breakStack;
vector<Literal> literals;
vector<GoToLabel> gotos;
vector<Procedure> procs;
vector<arrayType> arrays;

/*
*
*	END CONSTANT DECLARATIONS
*
*/


//  Error in the grammar of the source code
//  End the program, spit out the error
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

//Check if the token matches expected token
//If it does, get the next one
bool match_token(string a, string b){
	if(a == b){
		tok = getNext();
		return true;
	}
	return false;
}

//Grab input file name, set up file output
void setupInput(int argc, char** argv){
    if(argc <= 1){
        cerr << "Invalid input file" << endl;
        exit(EXIT_FAILURE);
    }
    setInFile(argv[1]);
}

//Take setup options, setup output files
void setupOptions(int argc, char** argv){
    outFileName = "a.asm";
    execFileName = "a.out";
    keepAsm = false;
    for(int i = 2; i < argc; i++){
        string option = argv[i];
        if(option == "-o"){
            i++;
            execFileName = argv[i];
        }else if(option == "-s"){
            i++;
            outFileName = argv[i];
            keepAsm = true;
        }
    }
    outFile.open(outFileName.c_str());
}

//Run through the code and fill in header information for procedures
void loadProcVector(){
    sym = nextSym();
    tok = getNext();
    while(!inFile.eof()){
        bool end = false;
        while(tok.lexeme != "procedure"){
            if(inFile.eof()){
                end = true;
                break;
            }
            tok = getNext();
        }
        if(end){
            break;
        }
        tok = getNext();
        string procName = tok.lexeme;
        Procedure proc;
        vector<Argument> args;
        proc.name = procName;
        tok = getNext();
        if(!match_token(tok.lexeme, "(")){
            error();
        }
        bool callBy = match_token(tok.lexeme, "var");
        Argument arg;
        string argName = tok.lexeme;
        while(match_token(tok.tokenName, "Identifier")){
            arg.name = argName;
            if(callBy){
                arg.callBy = true;
            }else{
                arg.callBy = false;
            }
            if(!match_token(tok.lexeme, ":")){
                error();
            }
            string type = findTypeName();
            arg.type = type;
            if(arg.type != REAL && arg.type != BOOL && arg.type != INT && arg.type != STRING){
                arg.callBy = true;
            }
            args.push_back(arg);
            if(!match_token(tok.lexeme, ",")){
                break;
            }


            callBy = match_token(tok.lexeme, "var");
            argName = tok.lexeme;
        }
        if(!match_token(tok.lexeme, ")")){
            error();
        }
        if(!match_token(tok.lexeme, ":")){
            if(match_token(tok.lexeme, ";")){
                proc.returnType = NONE;

            }else{
                error();
            }
        }else{
            string type = findTypeName();
            proc.returnType = type;
        }
        proc.args = args;
        proc.entryLabel = "Entry_" + proc.name;
        proc.exitLabel = "Exit_" + proc.name;
        procs.push_back(proc);

    }
}


//Run through the code and note values of constant variables
        //Required for constant-length arrays
void loadConstValues(){
    sym = nextSym();
    tok = getNext();
    while(tok.lexeme != "const" && !inFile.eof()){
        tok = getNext();
    }
    if(inFile.eof()){
        return;
    }
    tok = getNext();
    string name = tok.lexeme;
    while(match_token(tok.tokenName, "Identifier")){
        if(!match_token(tok.lexeme, ":")){
            error();
        }
        string val = tok.lexeme;
        if(match_token(tok.tokenName, "number")){
            namedInt x;
            x.name = name;
            x.val = atoi(val.c_str());
            ints.push_back(x);
        }else{
            tok = getNext();
        }

        if(!match_token(tok.lexeme, ";")){
            error();
        }
        name = tok.lexeme;
    }



}

//Run through code and keep track of array type declarations
void loadArrTypes(){
    sym = nextSym();
    tok = getNext();
    while(tok.lexeme != "type" && !inFile.eof()){

        tok = getNext();
    }
    if(inFile.eof()){
        return;
    }
    tok = getNext();
    string arrName = tok.lexeme;
    while(match_token(tok.tokenName, "Identifier")){
        arrayType arr;
        arr.name = arrName;
        if(!match_token(tok.lexeme, ":")){
            error();
        }
        if(!match_token(tok.lexeme, "array")){
            error();
        }
        if(!match_token(tok.lexeme, "[")){
            error();
        }
        string num = tok.lexeme;
        if(match_token(tok.tokenName, "number")){
            arr.capacity = atoi(num.c_str());
        }else if(match_token(tok.tokenName, "Identifier")){
            namedInt x;
            bool found = false;
            for(int i = 0; i < ints.size(); i++){
                x = ints.at(i);
                if(x.name == num){
                    found = true;
                    arr.capacity = x.val;
                }
            }
            if(!found){
                error();
            }
        }else{
            error();
        }

        if(!match_token(tok.lexeme, "]")){
            error();
        }
        if(!match_token(tok.lexeme, "of")){
            error();
        }
        string type = findTypeName();
        arr.type = type;
        if(type == REAL){
            arr.storageUnit = 8;
        }else{
            arr.storageUnit = 4;
        }
        arr.memReq = arr.capacity*arr.storageUnit;
        arrays.push_back(arr);
        if(!match_token(tok.lexeme, ";")){
            error();
        }




        arrName = tok.lexeme;
    }



}

//Assemble the generated assembly code
void assemble(){
    string cmd = "nasm -felf32 " + outFileName +
                 " -o a.o && gcc -m32 a.o -o " + execFileName;
    //cerr << cmd << endl;
    system(cmd.c_str());
    system("rm a.o");
    if(!keepAsm){
        system(("rm " + outFileName).c_str());
    }
}


int main(int argc, char** argv){
    setupInput(argc, argv);
    setupOptions(argc, argv);
    loadConstValues();
    resetFileIO();
    loadArrTypes();
    resetFileIO();
    loadProcVector();
    resetFileIO();
	sym = nextSym();
	tok = getNext();
	printIntro();
	klump_program();
	printOutro();
    assemble();
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
		if(const_definitions() == FOUND && type_definitions() == FOUND && dcl_definitions(GLOBAL) == FOUND /*&& proc_declarations() == FOUND*/){
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

// <const_list> -> {IDENTIFIER : <const> ;}+
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

//<const> -> NUMBER | DECIMAL | CSTRING
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

//<type_definitions> -> TYPE <type_list> | e
int type_definitions(){
	if(match_token(tok.lexeme, "type")){
		if(type_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}


//<type_list> -> {IDNETIFIER : <structure_type>;}+
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

//<struct_type> -> <array_type> | <record_type>
int struct_type(){
	if(array_type() == DOES_NOT_MATCH){
		return record_type();
	}

	return FOUND;
}

// <array_type> -> ARRAY | NUMBER | OF <dcl_type>
int array_type(){
	if(match_token(tok.lexeme, "array")){
		if(match_token(tok.lexeme, "[")
		&& (match_token(tok.tokenName, "number") || match_token(tok.tokenName, "Identifier"))
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

//record_type> -> RECORD <fld_list> END
int record_type(){
	if(match_token(tok.lexeme, "record")){
		if(fld_list() == FOUND && match_token(tok.lexeme, "end")){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<fld_list> -> {IDENTIFIER : <dcl_type> ;}+
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

//<dcl_definitions> -> DCL <dcl_list> | e
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

// <dcl_list> -> {IDENTIFIER : dcl_type;}+
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
                    arrayType arr = getArrType(t2.lexeme);
                    id.offset = storage + arr.memReq;
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

//<dcl_type> -> <atomic_type> | IDENTIFIER
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

// <atomic_type> -> BOOL | INT | REAL | STRING
int atomic_type(){
	if(match_token(tok.lexeme, "bool") || match_token(tok.lexeme, "real")
		|| match_token(tok.lexeme, "int") || match_token(tok.lexeme, "string")){
			return FOUND;
		}
	return DOES_NOT_MATCH;
}

// <proc_declarations> -> PROC <signature_list> | e
int proc_declarations(){
	if(match_token(tok.lexeme, "proc")){
		if(signature_list() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

//<signature_list> -> <proc_signature>{;<proc_signature>}* | e
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

//<proc_signature> -> IDENTIFIER <formal_args><return_type>;
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


//<formal_arg> -> <call_by> IDENTIFIER : <dcl_type>
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

//<formal_arg_list> -> <formal_arg> {, <formal_arg>}*
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

//<formal_arg> -> <call_by> IDENTIFIER : <dcl_type>
int formal_arg(){
	if(call_by() == FOUND){
		if(match_token(tok.tokenName, "Identifier") && match_token(tok.lexeme, ":") && dcl_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}


//<call_by> -> VAR | e
int call_by(){
	if(match_token(tok.lexeme, "var")){
		return FOUND;
	}

	return FOUND;
}


//<return_type> -> <atomic_type> | e
int return_type(){
	if(match_token(tok.lexeme, ":")){
		if(atomic_type() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}


//<actual_args> -> {<actual_arg_list>} | e
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

//<actual_arg_list> -> <actual_arg> {, <actual_arg> }*
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

//<actual_arg> -> <expression>
int actual_arg(){
	return expression();
}


//<procedure_list> -> {<procedure>}*
int procedure_list(){
	while(procedure() == FOUND){
		localVars.clear();
		gotos.clear();
        while(!nextStack.empty()){
            nextStack.pop();
        }
        while(!breakStack.empty()){
            breakStack.pop();
        }
	}
	return FOUND;
}

//<procedure> -> <proc_head><proc_body>
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


//<proc_head> -> PROCEDURE IDENTIFIER;
int proc_head(){
	if(match_token(tok.lexeme, "procedure")){
		string name = tok.lexeme;
		if(match_token(tok.tokenName, "Identifier")){
			currentProc = name;
			Procedure proc = findProc(currentProc);
			loadArgsToLocalVariables(proc);
            if(!match_token(tok.lexeme, "(")){
                error();
            }
            match_token(tok.lexeme, "var");
            while(match_token(tok.tokenName, "Identifier")){
                if(!match_token(tok.lexeme, ":")){
                    error();
                }
                findTypeName();
                if(!match_token(tok.lexeme, ",")){
                    break;
                }
                match_token(tok.lexeme, "var");
            }
            if(!match_token(tok.lexeme, ")")){
                error();
            }
            if(match_token(tok.lexeme, ":")){
                findTypeName();
            }
			if(match_token(tok.lexeme, ";")){
				return FOUND;
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<proc_body> -> <dcl_definitions> BEGIN <statement_list> END
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

//<statement_list> -> {<statement>}*
int statement_list(){
	while(statement() == FOUND){

	}
	return FOUND;
}

//<statement> -> <label><exec_statement>
int statement(){
	if(label() == FOUND){
		if(exec_statement() == FOUND){
			return FOUND;
		}
		return DOES_NOT_MATCH;
	}
	return DOES_NOT_MATCH;
}

//<label> -> # NUMBER | e
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

// <exec_statement> -> <read_statement>
//                  | <write_statement>
//                  | <assign_statement>
//                  | <call_statement>
//                  | <return_statement>
//                  | <goto_statement>
//                  | <empty_statement>
//                  | <compound_statement>
//                  | <if_statement>
//                  | <while_statement>
//                  | <case_statement>
//                  | <for_statement>
//                  | <next_statement>
//                  | <break_statement>
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

//<read_statement> -> READ <actual_args> ; | READLN <actual_args> ;
int read_statement(){
	string call = tok.lexeme;
	if(match_token(tok.lexeme, "read") || match_token(tok.lexeme, "readln")){
		if(match_token(tok.lexeme, "(")){
			string id = tok.lexeme;
			while(match_token(tok.tokenName, "Identifier")){
    			Variable idToWrite;
    			idToWrite = getVariable(id);
                string type = idToWrite.type;
                loadAddr(idToWrite);
                if(type != INT && type != REAL && type != BOOL && type != STRING){
                    arrayType arr = getArrType(idToWrite.type);
                    typeStack.push(arr.name);
                    qualifier(arr);
                }else{
                    typeStack.push(type);
                }
                type = typeStack.top();
                if(type == INT){
                    addLine("", "push", "intFrmtIn", "");
                }else if(type == REAL){
                    addLine("", "push", "realFrmtIn", "");
                }else if(type == STRING){
                    addLine("", "push", "stringFrmtIn", "");
                }else{
                    cerr << "Cannot input type " << type << endl;
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

//<write_statement> -> WRITE <actual_args> | WRITELN <actual_args>;
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

/*
int assign_statement(){
	token t = tok;
	if(match_token(tok.tokenName, "Identifier")){
		// Have we seen this identifier declared?
		Variable id  = getVariable(t.lexeme);
        bool dealingWithArr = false;
		if(match_token(tok.lexeme, "[")){
            dealingWithArr = true;
            if(expression() != FOUND){
                error();
            }
            if(typeStack.top() != INT){
                cerr << "Invalid type " << typeStack.top() << endl;
            }
            if(!match_token(tok.lexeme, "]")){
                error();
            }

        }else if(id.type != REAL && id.type != BOOL && id.type != INT && id.type != STRING){
            //We're looking at an array lval without a qualifier.
            if(!match_token(tok.lexeme, ":=")){
                error();
            }
            string name = tok.lexeme;
            if(!match_token(tok.tokenName, "Identifier")){
                error();
            }
            Variable lId = id;
            Variable rId = getVariable(name);
            if(lId.type == rId.type){
                string top = generateLabel();
                loadAddr(lId);
                loadAddr(rId);
                addLine("", "pop", "esi", "Pop copy address to edi");
                addLine("", "pop", "edi", "Pop original address to esi");
                addLine("", "mov", "eax, 0", "Set offset to 0");
                addLine("", "mov", "ebx, " + appendString("", getArrType(lId.type).memReq), "Set target offset in ebx");
                addLine(top, "", "", "Start copying");
                addLine("", "push", "dword [esi + eax]", "Push source copy to stack");
                addLine("", "pop", "dword [edi + eax]", "Pop copy to destination copy");
                addLine("", "add", "eax, 4", "Increment offset");
                addLine("", "cmp", "eax, ebx", "Compare offset to storage size");
                addLine("", "jl", top, "If it's less than, jump back to the top");

                if(!match_token(tok.lexeme, ";")){
                    error();
                }else{
                    return FOUND;
                }


            }else{
                cerr << "Incompatible assign" << endl;
            }
        }
		if(match_token(tok.lexeme, ":=")){
			if(expression() == FOUND){						//Find an expression and push it to the stack
				string typeTwo = typeStack.top();
				typeStack.pop();
                string typeOne;
                loadAddr(id);
                if(dealingWithArr){
                    arrayType arr = getArrType(id.type);
                    int offsetLoc;
                    if(typeTwo == REAL){
                        offsetLoc = 12;
                    }else{
                        offsetLoc = 8;
                    }
                    addLine("", "mov", "ebx, " + appendString("[esp + ", offsetLoc) + "]", "Move offset from array head to eax");
                    addLine("", "pop", "eax", "Pop array location");
                    addLine("", "lea", "eax, [eax + " + appendString("", arr.storageUnit) + "*ebx]", "Calculate offset");  //lea eax, [eax + storageUnite*ebx];
                    addLine("", "push", "eax", "Push new address to stack");
                    typeOne = arr.type;
                }else{
                    typeOne = id.type;
                }
                addAssign(typeTwo, typeOne);

                if(dealingWithArr){
                    addLine("", "add", "esp, 4", "Remove offset from stack");
                }
				if(match_token(tok.lexeme, ";")){
					return FOUND;
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}*/


//<assign_statement> -> <lval> := <expression> ;
int assign_statement(){
    string id = tok.lexeme;
    if(match_token(tok.tokenName, "Identifier")){
        Variable var = getVariable(id);
        loadAddr(var);
        if(var.type != BOOL && var.type != STRING && var.type != INT && var.type != REAL){
            arrayType arr = getArrType(var.type);
            typeStack.push(arr.name);
            qualifier(arr);
        }else{
            typeStack.push(var.type);
        }
        string typeOne = typeStack.top();
        typeStack.pop();

        if(!match_token(tok.lexeme, ":=")){
            error();
        }
        if(expression() != FOUND){
            error();
        }

        addLine("", "pop", "eax", "Reorder address and expression on stack");
        if(typeStack.top() == REAL){
            addLine("", "pop", "ebx", "Pop second part of real to ebx");
        }
        addLine("", "pop", "ecx", "Pop address to stack");

        if(typeStack.top() == REAL){
            addLine("", "push", "ebx", "Push first part of real to stack");
        }
        addLine("", "push", "eax", "Push expression back to stack");
        addLine("", "push", "ecx", "Push address to stack");

        string typeTwo = typeStack.top();
        typeStack.pop();
        addAssign(typeTwo, typeOne);

        if(!match_token(tok.lexeme, ";")){
            error();
        }
        return FOUND;



    }

    return DOES_NOT_MATCH;
}

//<call_statement> -> CALL IDENTIFIER <actual_args> ;
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


//<return_statement> -> RETURN <expression>;
int return_statement(){
	if(match_token(tok.lexeme, "return")){
            Procedure proc = findProc(currentProc);
            if(proc.returnType == NONE){
                if(!match_token(tok.lexeme, ";")){
                    error();
                }
                addLine("", "jmp", proc.exitLabel, "Jump to function exit");
                return FOUND;
            }else if(expression() == FOUND){

					if(proc.returnType == REAL){
						if(typeStack.top() == REAL){
							addLine("", "movsd", "xmm0, [esp]", "Move return value to xmm0");
							addLine("", "add", "esp, 8", "");
						}else if(typeStack.top() == INT){
							addLine("", "fild", "dword [esp]", "");
                            addLine("", "sub" , "esp, 4", "");
							addLine("", "fstp", "qword [esp]", "Move return value to xmm0");
                            addLine("", "movsd", "xmm0, [esp]", "");
                            addLine("", "add", "esp, 8", "");
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


// <goto_statement> -> GOTO <label> ;
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


//<empty_statement> -> ;
int empty_statement(){
	if(match_token(tok.lexeme, ";")){
		return FOUND;
	}
	return DOES_NOT_MATCH;
}

//<compound_statement> -> DO ; <statement_list> END;
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

// <if_statement> -> IF (<comparison>) THEN <statement> <else_clause>
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


//<else_clause> -> ELSE <statement> | e
int else_clause(){
	if(match_token(tok.lexeme, "else")){
		if(statement() == FOUND){
			return FOUND;
		}
		error();
	}
	return FOUND;
}

//<while_statement> -> WHILE(<comparison>)<statement>
int while_statement(){
	if(match_token(tok.lexeme, "while")){
		if(match_token(tok.lexeme, "(")){
			string headOfWhileLoop = generateLabel();
			string endOfWhileLoop = generateLabel();
            nextStack.push(headOfWhileLoop);
            breakStack.push(endOfWhileLoop);
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
					if(statement() == FOUND){
						addLine("", "jmp", headOfWhileLoop, "Jump back to the top of while loop");
						addLine(endOfWhileLoop, "", "", "Destination if while condition fails");
                        nextStack.pop();
                        breakStack.pop();
						return FOUND;
					}
				}
			}
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<case_statement> -> CASE (<expression>) <case_list>
int case_statement(){
	if(match_token(tok.lexeme, "case")){
		if(match_token(tok.lexeme, "(")){
			if(expression() == FOUND){
				if(match_token(tok.lexeme, ")")){
                    addLine("", "pop", "eax", "Pop case expression to eax");
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


//<case_list> -> {<unary> NUMBER : <statement>}* DEFAULT : <statement>
int case_list(){
    string done = generateLabel();
	string un = tok.lexeme;
    unary();
    string type = tok.tokenName;
    while(_const() == FOUND){
        string nextLabel = generateLabel();
        if(typeStack.top() != INT){
            error();
        }
        typeStack.pop();
        addLine("", "pop", "ebx", "Remove case instance value from stack");
        if(un == "-"){
            addLine("", "neg", "ebx", "Add unary negative");
        }

        addLine("", "cmp", "eax, ebx", "Compare case expression to instance");
        addLine("", "jne", nextLabel, "");
        if(!match_token(tok.lexeme, ":")){
            error();
        }
        if(statement() != FOUND){
            error();
        }
        addLine("", "jmp", done, "Jump to end of case_statement");
        addLine(nextLabel, "", "", "Try next case instance");
    }

    if(!match_token(tok.lexeme, "default")){
        error();
    }
    if(!match_token(tok.lexeme, ":")){
        error();
    }
    if(statement() != FOUND){
        error();
    }
    addLine(done, "", "", "End of case statement");
	return FOUND;

}

//<for_statement> -> FOR IDENTIFIER := <expression> {TO | DOWNTO} <expression> <statement>
int for_statement(){
	if(match_token(tok.lexeme, "for")){
        Variable id = getVariable(tok.lexeme);
        if(!(id.type == INT)){
            cerr << "Cannot use " << id.type << " as loop counter" << endl;
        }
        string topLabel = generateLabel();
        string exitLabel = generateLabel();
        string nextLabel = generateLabel();
        breakStack.push(exitLabel);
        nextStack.push(nextLabel);
		if(match_token(tok.tokenName, "Identifier")){
			if(match_token(tok.lexeme, ":=")){
				if(expression() == FOUND){
                    loadAddr(id);
                    string exprType = typeStack.top();
                    typeStack.pop();
                    addAssign(exprType, id.type);
                    string direction = tok.lexeme;
					if(match_token(tok.lexeme, "to") || match_token(tok.lexeme, "downto")){
                        addLine(topLabel, "", "", "Begin compiling for expression");
						if(expression() == FOUND){
                            if(!(typeStack.top() == INT)){
                                cerr << "Invalid type for for-loop condition: " << typeStack.top();
                                error();
                            }
                            typeStack.pop();
                            loadAddr(id);
                            addLine("", "pop", "esi", "Pop address to counter variable");
                            addLine("", "mov", "dword eax, [esi]", "");
                            addLine("", "pop", "ebx", "Remove for-condition for comparison");
                            addLine("", "cmp", "eax, ebx", "");
                            if(direction == "downto"){
                                addLine("", "jl", exitLabel, "");
                            }else{
                                addLine("", "jg", exitLabel, "");
                            }
							if(statement() == FOUND){
                                addLine(nextLabel, "", "", "End-of-loop maintenance");
                                loadAddr(id);
                                addLine("", "pop", "esi", "");
                                addLine("", "mov", "dword eax, [esi]", "");
                                if(direction == "downto"){
                                    addLine("", "dec", "eax", "Decrement Loop Counter");
                                }else{
                                    addLine("", "inc", "eax", "Increment Loop Counter");
                                }
                                addLine("", "mov", "[esi], eax", "Put updated Loop Counter into memory location");
                                addLine("", "jmp", topLabel, "");
                                addLine(exitLabel, "", "", "Exit destination for loop");
                                //addLine("", "add", "esp, 4", "Remove counter from stack");
                                nextStack.pop();
                                breakStack.pop();
								return FOUND;
							}else{
                                error();
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


//<next_statement> -> NEXT;
int next_statement(){
	if(match_token(tok.lexeme, "next")){
		if(match_token(tok.lexeme, ";")){
            addLine("", "jmp", nextStack.top(), "Jump to top of loop");
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<break_statement> -> BREAK;
int break_statement(){
	if(match_token(tok.lexeme, "break")){
		if(match_token(tok.lexeme, ";")){
            addLine("", "jmp", breakStack.top(), "Jump to end of loop");
			return FOUND;
		}
		error();
	}
	return DOES_NOT_MATCH;
}

//<expression> -> <comparison>
int expression(){
	return comparison();
}

//<comparison> -> <simple_expression> {<compop><simple_expression>}*
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
							addLine("", "fild", "dword [esp + 4]", "Load int to floating point stack");
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

//<simple_expression> -> <unary><term> {<addop><term>}*
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
					}else if(typeOne == BOOL && typeTwo == BOOL){
                        addLine("", "pop", "ebx", "Remove operands from stack for mulop");
                        addLine("", "pop", "eax", "");
                        if(op == "or"){
                            addLine("", "or", "eax, ebx", "");
                        }else{
                            error();
                        }
                        typeStack.push(BOOL);
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


//<term> -> <factor>{<mulop><factor>}*
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

//<factor> -> <const> | <func_ref> | <lval> | (<expression) | NOT <factor>
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
            if(typeStack.top() == BOOL){
                string equalLabel = generateLabel();
                string endLabel = generateLabel();
                addLine("", "pop", "eax", "Pop bool to eax for NOT operator");
                addLine("", "mov", "ebx, 0", "Move 0 into ebx to compare for NOT operator");
                addLine("", "cmp", "eax, ebx", "");
                addLine("", "je", equalLabel, "If equal jump to push 1");
                addLine("", "push", "0", "");
                addLine("", "jmp", endLabel, "Jump to end to skip pushing 1");
                addLine(equalLabel, "", "", "");
                addLine("", "push", "1", "");
                addLine(endLabel, "", "", "");
            }else{
                cerr << "Incompatible operand for NOT " << typeStack.top();
                error();
            }
			return FOUND;
		}
		error();
	}
    if(match_token(tok.lexeme, "randint")){
        if(!match_token(tok.lexeme, "(")){
            error();
        }
        addLine("", "sub", "esp, 4", "Make room for file descriptor later");
        if(expression() != FOUND){
            error();
        }
        if(typeStack.top() != INT){
            cerr << "Arguments to randint must be integers" << endl;
            error();
        }
        typeStack.pop();
        if(!match_token(tok.lexeme, ",")){
            error();
        }
        if(expression() != FOUND){
            error();
        }
        if(typeStack.top() != INT){
            cerr << "Arguments to randint must be integers" << endl;
            error();
        }
        typeStack.pop();

        addLine("", "mov", "eax, 5", "Move sys_open call to eax");
        addLine("", "mov", "ebx, randIn", "filename to ebx");
        addLine("", "mov", "ecx, 0", "Permissions are read-only");
        addLine("", "int", "0x80", "syscall");
        addLine("", "mov", "[esp + 8], eax", "Store file descriptor");
        addLine("", "mov", "ebx, eax", "Move file descriptor to ebx");
        addLine("", "mov", "eax, 3", "Move sys_read call to eax");
        addLine("", "sub", "esp, 4", "Make room for read integer");
        addLine("", "mov", "ecx, esp", "Make input pointer esp");
        addLine("", "mov", "edx, 4", "Input 4 bytes");
        addLine("", "int", "0x80", "syscall");

        addLine("", "mov", "eax, [esp + 4]", "Move upper bound to eax");
        addLine("", "mov", "ebx, [esp + 8]", "Move lower bound to ebx");

        addLine("", "sub", "eax, ebx", "Calculate randint range");
        addLine("", "push", "eax", "Push range to stack");
        string end = generateLabel();

        addLine("", "mov", "ebx, 0", "");
        addLine("", "cmp", "eax, ebx", "Test if the range is 0");
        addLine("", "je", end, "If it is, jump to the end");

        addLine("", "mov", "eax, [esp + 4]", "Move random int to eax");
        addLine("", "mov", "ebx, [esp]", "Move range to ebx");
        addLine("", "cdq", "", "");
        addLine("", "idiv", "ebx", "");
        addLine("", "mov", "eax, edx", "");

        //Modulo'd result is now in eax

        addLine("", "mov", "ebx, 0", "");
        addLine("", "cmp", "eax, ebx", "Compare if the result is negative");
        addLine("", "jge", end, "If it's not, jump to the end");

        addLine("", "mov", "ebx, [esp]", "Move range to ebx");
        addLine("", "add", "eax, ebx", "Increment result by range");

        addLine(end, "", "", "");
        addLine("", "mov", "ebx, [esp + 12]", "Move lower bound to ebx");
        addLine("", "add", "eax, ebx", "Add lower bound to result");
        addLine("", "add", "esp, 16", "Clean up stack");

        addLine("", "pop", "ebx", "Move file descriptor for /dev/urandom");
        addLine("", "push", "eax", "Push result to stack");

        addLine("", "mov", "eax, 6", "sys_close");
        addLine("", "int", "0x80", "");




        typeStack.push(INT);
        if(!match_token(tok.lexeme, ")")){
            error();
        }


        return FOUND;



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
		}else{
            Variable var = getVariable(id);
            loadAddr(var);
            if(var.type != BOOL && var.type != STRING && var.type != INT && var.type != REAL){
                arrayType arr = getArrType(var.type);
                typeStack.push(arr.name);
                qualifier(arr);
            }else{
                typeStack.push(var.type);
            }
            string type = typeStack.top();
            if(type == REAL || type == STRING || type == BOOL || type == INT){
                addLine("", "pop", "esi", "Pop address to esi");
                if(typeStack.top() == REAL){
                    addLine("", "push", "dword [esi + 4]", "Push first half of real to stack");
                }
                addLine("", "push", "dword [esi]", "Push factor to stack");
            }
            return FOUND;

        }


	}

	return DOES_NOT_MATCH;
}

//<compop> -> = | <> | > | < | >= | <=
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

//<addop> -> + | - | OR
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

//<mulop> -> * | / | % \ AND
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

//<unary> -> + | - | e
int unary(){
	if(match_token(tok.lexeme, "+")){
		return FOUND;
	}else if(match_token(tok.lexeme, "-")){
		return FOUND;
	}else{
		return FOUND;
	}
}

//<qualifier> -> [<expression>] <qualifier>
//            | . IDENTIFER <qualifier>
//            | e
int qualifier(arrayType type){
	if(match_token(tok.lexeme, "[")){
        typeStack.pop();
        typeStack.push(type.type);
		if(expression() == FOUND){
            if(typeStack.top() != INT){
                cerr << "Invalid type " << typeStack.top() << " for index" << endl;
                error();
            }
            typeStack.pop();
            addLine("", "pop", "ebx", "Pop offset expression to ebx");
            addLine("", "pop", "eax", "Pop head address to eax");
            addLine("", "lea", "eax, [eax + ebx*" + appendString("", type.storageUnit) + "]", "Calculate new offset");
            addLine("", "push", "eax", "Push new address to stack");
            if(!match_token(tok.lexeme, "]")){
                error();
            }
            if(type.type != BOOL && type.type != STRING && type.type != INT && type.type != REAL){
                qualifier(getArrType(type.type));
            }
        }
	}

	if(match_token(tok.lexeme, ".")){
		if(match_token(tok.tokenName, "Identifier")){
			if(qualifier(type) == FOUND){
				return FOUND;
			}
		}
		error();
	}

	return FOUND;
}


//Output Assembly Source Line
void addLine(string label, string opcode, string operands, string comment){

  if (label != "")
	 outFile << setw(15) << left << label + ":";
  else
	 outFile << setw(15) << left << " ";
  if (opcode != "")
	 outFile << setw(10) << left << opcode;
  else
	 outFile << setw(10) << left << " ";
  if (operands != "")
	 outFile << setw(20) << left << operands;
  else
	 outFile << setw(20) << left << " ";
  if (comment != "")
	 outFile << "\t" << ";" <<  comment;
  outFile << endl;
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

//Helper function. Append int to string
string appendString(string str, int n){
	stringstream ss;
	ss << str << n;
	return ss.str();
}

//Generate Address Calculation Code
string getOffsetString(int offset){
	stringstream ss;
	ss << "[ebp - " << offset << "]";
	return ss.str();
}

//Setup ASM source
void printIntro(){
	addLine("", "global", "main", "");
	addLine("", "extern", "printf", "");
	addLine("", "extern", "scanf", "");
	addLine("", "extern", "getchar", "");
	addLine("", "section", ".text", "");
	addLine("main", "", "", "");
}
//Declare Memory locations
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
    addLine("randIn", "db", "\"/dev/urandom\"", "File for random bytes");

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
		}
        else if(id.type == BOOL || id.type == INT || id.type == STRING){
			size = "4";
		}else{
            arrayType arr = getArrType(id.type);
            size = appendString("", arr.memReq);
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

//Swap float and int on top of stack
void swapTopOfStack(){
	addLine("", "movsd", "xmm0, [esp]", "Switch order of operands on stack");
	addLine("", "mov", "eax, [esp + 8]", "");
	addLine("", "movsd", "[esp + 4], xmm0", "");
	addLine("", "mov", "[esp], eax", "Finish pushing in reverse order");
}

//Convert int on stack to float
void convertTopOfStackToFloat(){
	addLine("", "fild", "dword [esp]", "Convert int on stack to float");
	addLine("", "sub", "esp, 4", "Make room on stack for float");
	addLine("", "fstp", "qword [esp]", "Put new float on stack");
}

//Print New Line in ASM source
void printNewLine(){
	addLine("", "push", "NewLine", "Push newline to stack for printf");
	addLine("", "call", "printf", "");
	addLine("", "add", "esp, 4", "Clean up stack after printf");

}

//Given two types on the stack, add them and add the result to the stack
void addAssign(string typeTwo, string typeOne){
	if(typeOne == REAL){
		if(typeTwo == INT){
			addLine("", "fild", "dword [esp + 4]", "Load top of stack to floating point stack");
			addLine("", "pop", "eax", "Store address in eax");
            addLine("", "sub", "esp, 4", "Make room for new float");
            addLine("", "push", "eax", "Push address back on stack");
			addLine("", "fstp", "qword [esp + 4]", "Convert 32-bit int to 64-bit float");
		}
		addLine("", "pop", "esi", "Pop address to esi");
        addLine("", "pop", "eax", "");
        addLine("", "pop", "ebx", "");
        addLine("", "mov", "[esi + 4], ebx", "Assign real in two parts");
        addLine("", "mov", "[esi], eax", "");
	}else if(typeOne == INT){
		if(typeTwo == REAL){
			addLine("", "movsd", "xmm0, [esp + 4]", "Move real into xmm0 for conversion");
            addLine("", "cvtsd2si", "eax, xmm0", "Convert real to int");
            addLine("", "pop", "esi", "Pop address to esi");
            addLine("", "mov", "[esi], eax", "Move converted float to address");
            addLine("", "add", "esp, 8", "Clean up stack");

		}else if(typeTwo == INT){
		    addLine("", "pop", "esi", "Pop address to esi");
            addLine("", "pop", "dword [esi]", "Pop expression to address in esi");
		}
	}else if(typeOne == STRING){
		addLine("", "pop", "esi", "Address to esi");
        addLine("", "pop", "dword [esi]", "Pop expression to address in esi");
	}else{

        //Dealing with an array Assign
        if(typeOne != typeTwo){
            cerr << "Unmatched types " << typeOne << " and " << typeTwo << endl;
            error();
        }
        arrayType arrLeft = getArrType(typeOne);
        arrayType arrRight = getArrType(typeTwo);
        addLine("", "nop", "", "Begin copying array");
        addLine("", "pop", "edi", "Pop array address to edi");
        addLine("", "pop", "esi", "Pop copied array to esi");
        string topLabel = generateLabel();
        addLine("", "mov", "eax, 0", "Start offset at 0");
        addLine("", "mov", "ebx, " + appendString("", arrLeft.memReq), "Move array size to ebx");
        addLine(topLabel, "", "", "");
        addLine("", "push", "dword [esi + eax]", "Push 32 bits from source array");
        addLine("", "pop", "dword [edi + eax]", "Pop 32 bits to destination array");
        addLine("", "add", "eax, 4", "Increment offset by four bytes");
        addLine("", "cmp", "eax, ebx", "Compare offset to size");
        addLine("", "jl", topLabel, "If it's less than, jump back to the top");
    }



}

//Return Variable info given name
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

//Return proc info given name
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

//Convert int on top of stack to real
void convertIntToReal(){
	addLine("", "fild", "dword [esp]", "Convert Int to Real");
	addLine("", "sub", "esp, 4", "");
	addLine("", "fstp", "qword [esp]", "Done converting int to real");
}


void processArgs(Procedure proc){
	vector<Argument> args = proc.args;
	for(int i = 0; i < args.size(); i++){
		Argument arg = args.at(i);
		if(arg.callBy){
            string id = tok.lexeme;
            if(match_token(tok.tokenName, "Identifier")){
                Variable var = getVariable(id);
                if(var.type == arg.type){
                    loadAddr(var);
                }else{
                    cerr << "Actual arg doesn't match formal arg" << endl;
                    error();
                }
                if(!match_token(tok.lexeme, ",")){
					if(i != args.size() - 1){
						error();
					}
				}
            }
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
// Create local variable information for function arguments
void loadArgsToLocalVariables(Procedure proc){
	int offset = -8;
	vector<Argument> args = proc.args;
	for(int i = args.size() - 1; i >= 0; i--){
		Variable var;
		Argument arg = args.at(i);
		if(!arg.callBy){
			var.scope = LOCAL;
		}else{
            var.scope = CALLBY;
        }
		var.kName = arg.name;
		var.offset = offset;
		var.type = arg.type;
		if(arg.type == REAL && !arg.callBy){
			offset = offset - 8;
		}else{
			offset = offset - 4;
		}

		localVars.push_back(var);
	}

}

//Clean up stack after function
void removeArgsFromStack(Procedure proc){
	int size = 0;
	for(int i = 0; i < proc.args.size(); i++){
		if(proc.args.at(i).type == REAL && !proc.args.at(i).callBy){
			size += 8;
		}else{
			size += 4;
		}
	}
	addLine("", "add", appendString("esp, ", size), "Remove args from stack");
}

//Given variable, put its address on the stack
void loadAddr(Variable var){
    if(var.scope == LOCAL){
        addLine("", "lea", "eax, " + getOffsetString(var.offset), "Load address into eax");
        addLine("", "push", "eax", "");
    }else if(var.scope == GLOBAL || var.scope == CONST){
        addLine("", "lea", "eax, [" + var.aName + "]", "Load address into eax");
        addLine("", "push", "eax", "");
    }else if(var.scope == CALLBY){
        addLine("", "push", "dword " + getOffsetString(var.offset), "Load callBy address onto stack");
    }
}

//Convert source type to internal type
string findTypeName(){
    string type = tok.lexeme;
    if(match_token(tok.lexeme, "int")){
        return INT;
    }else if(match_token(tok.lexeme, "real")){
        return REAL;
    }else if(match_token(tok.lexeme, "bool")){
        return BOOL;
    }else if(match_token(tok.lexeme, "string")){
        return STRING;
    }else if(match_token(tok.tokenName, "Identifier")){
        return type;
    }

    return NONE;
}

//Return array info given name
arrayType getArrType(string name){
    for(int i = 0; i < arrays.size(); i++){
        if(arrays.at(i).name == name){
            return arrays.at(i);
        }
    }
    cerr << "Unknown type " << name << endl;
    error();
    arrayType arr;
    return arr;
}
