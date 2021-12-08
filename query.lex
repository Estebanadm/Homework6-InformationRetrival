
/*----------------------------------------------------------------*/
/* Filename:  multiplefiles.lex                                   */
/* To compile: flex multiplefiles.lex                             */
/*            g++ -o multiplefiles lex.yy.c -lfl                  */
/* Flex can also use gcc or cc instead of g++                     */
/* Takes in and out directories: ./multiplefiles <indir> <outdir */
/*----------------------------------------------------------------*/

%{
#include <string.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>

extern int yylex(void);
using namespace std;

#undef yywrap            // safety measure in case using old flex 

const unsigned long NUM_KEYS = 150000;//5;
const int DICT_RECORD_SIZE = 28;
const int POST_RECORD_SIZE = 10;
const int MAP_RECORD_SIZE = 18;
const int TOKEN_SIZE = 14;

string DICT_FILE = "/dict.txt";
string POST_FILE = "/post.txt";
string MAP_FILE = "/map.txt";

string QueryBuffer = "";
vector<bool> requiredTerms;
vector<bool> excludedTerms;
vector<string> queryTerms;
int numTermsRequired=0;
int numTermsExcluded=0;
int numTerm=0;
//---------  INSERT ANY CODE CALLED BY THE LEX RULES HERE --------

/* Name:  Selection sort
 * Parameters:  accumulator: array storing the sum weight of query term in
 *                           matching files
 *              map: array sorted with accumulator for correct map file
 *              size: size of the arrays
 * Purpose:  sort the accumulator array From largest to smallest, sort map
 *           array in the same order as accumulator
 * Returns:  nothing
*/
void SelectionSort(int* accumulator, int*map, int size) {
  int i, j, max, temp;

  for(i = 0; i < (size-1); i++) {
    max = i;
    for(j = i+1; j < size; j++) {
      if(accumulator[j] > accumulator[max]) {
        max = j;
      }
    }
    if(max != i) {
      temp = accumulator[i];
      accumulator[i] = accumulator[max];
      accumulator[max] = temp;

      temp = map[i];
      map[i] = map[max];
      map[max] = temp;
    }
  }
}
//Detect if the token is a required token or a excluded term
int detectRequiredOrExcluded(string token){
  int excludedOrRequired=0;
  if(token.at(0)=='+'){
    excludedOrRequired=1;
  }else if(token.at(0)=='-'){
    excludedOrRequired=2;
  }
  return excludedOrRequired;
}
/* Name:  QuickTokenize
 * Parameters:  tokenbuffer: empty char string to store tokenized string
 * Purpose:  Tokenize input from command line into a string
 * Returns:  nothing
*/
void QuickTokenize(char* tokenbuffer, const string input){
	QueryBuffer =  "";
	yyin = tmpfile();
	fprintf(yyin, "%s", input.c_str());
	rewind(yyin);
	yylex();
	fclose (yyin);
	strcpy(tokenbuffer, QueryBuffer.c_str());
  //cout<<"Token Buffer"<<tokenbuffer<<endl;
	QueryBuffer =  "";
}

/* Name:  Downcase
 * Parameters:  Str[]: token that will be downcased
 * Purpose:  downcase token if it is alphabetical
 * Returns:  nothing
*/
void Downcase (const char Str[]) {
  char word[100];
  int i = 0;

  for (i=0; i < (int)strlen(Str); i++) {
    if ('A' <= Str[i] && Str[i] <= 'Z')
      word[i] = (char) ('a' + Str[i] - 'A');
    else
      word[i] = Str[i]; 
  }

  word[min(i, 100)] = '\0';
  QueryBuffer.append(word);
  QueryBuffer.append(" ");
}

/* Name:  PrintResults
 * Parameters:  Min: reference to the Map file
 *              accumulator: array storing the sum weight of query term in
 *                           matching files, initially unsorted
 *              map: array of map files, initially unsorted
 *              size: size of the arrays, size of the map file
 * Purpose:  calls sort then prints results of 10 highest matching
 *           if they are of weight higher than 0
 * Returns:  nothing
*/
void PrintResults(ifstream &Min, int* accumulator, int* map, int size,int* numRequired,int* numExcluded){
  int count = 0;
  string fileName = "";

  SelectionSort(accumulator, map, size);

  // Table Heading
  cout <<setw(17) << "Document" << " " << setw(4) << "Wt" << "<br>";

  // Print first 10 matching files if weight is greater than 0
  for(int i = 0; i < size; i++) {
    if(count > 9)
      break;   
       //cout<<numRequired[i]<<" num Term Required "<<numTermsRequired<<" "<<endl<<numExcluded[i] <<" num terms excldued "<<numTermsExcluded<<endl;
       if(numRequired[i]==numTermsRequired&&numExcluded[i]==0&&accumulator[i]>0) {
              count++;
      if((0 <= map[i]) && (map[i] < size)) {
        Min.seekg(map[i] * MAP_RECORD_SIZE, ios::beg);
        Min >> fileName;
        Min.clear();
        Min.seekg(0);
      }
      cout << setw(17) << "<a href=files/" << fileName << ">" << fileName << "</a>" << setw(4) << accumulator[i] << "<br>";
    }
  }
}

/* Name:  SearchPost
 * Parameters:  Pin: reference to the Post file
 *              RecordNum: record to start search
 *              numDocs: number of docs term is in
 *              accumulator: array storing the sum weight of query term in
 *                           matching files
 * Purpose:  searches the Post file from record number to how many documents
 *           it was in, update accumulator with sum of weight at the document
 * Returns:  nothing
 */
//Here I have to add the functionality for the boolean query
void SearchPost(ifstream &Pin, const int RecordNum, const int numDocs,
                   int* accumulator,int* numRequired,int* numExcluded) {
  int num_records = 0, docID = 0, termWt = 0;
  string line = "";
  //cout<<"Called"<<endl;
  // Get total number of records inside of Post file
  while(getline(Pin, line))
    num_records++;
  Pin.clear();
  Pin.seekg(0);

  if((0 <= RecordNum) && (RecordNum < num_records)) {
    Pin.seekg(RecordNum * POST_RECORD_SIZE, ios::beg);
    for(int i = 0; i < numDocs; i++) {
      Pin >> docID >> termWt;
      //if statement to add to the other lists
      //cout<<requiredTerms[numTerm]<<" "<<excludedTerms[numTerm]<<endl;
      if(requiredTerms[numTerm]==true){
        accumulator[docID] += termWt;
        numRequired[docID] ++;
      }else if(excludedTerms[numTerm]==true){
        accumulator[docID] -= termWt;
        numExcluded[docID] ++;
      }else{
        accumulator[docID] += termWt;
      }
    }
  }
  //cout<<numTerm<<endl;
  numTerm++;
  Pin.clear();
  Pin.seekg(0);
}

/* Name:  SearchDict
 * Parameters:  Din: reference to the Dict file
 *              RecordNum: record to start search
 *              term: string storing queried term
 *              numDocs: reference, stores number of docs term is in
 *              start: reference, stores starting location of term in post file
 * Purpose:  searches Dict file for queried term starting at the record number,
 *           if deleted or empty record stop searching
 * Returns:  true or false
*/
bool SearchDict(ifstream &Din, unsigned long RecordNum, const string term,
                   int &numDocs, int &start){
  bool Success = false;
  int num_records = 0;
  string line = "", token = "";

  // Get total number of records inside of Dict file
  while(getline(Din, line))
    num_records++;
  Din.clear();
  Din.seekg(0);
  
  if ((0 <= RecordNum) && (RecordNum < num_records)) {
    Din.seekg(RecordNum * DICT_RECORD_SIZE, ios::beg);
    while(Din >> token >> numDocs >> start) {
      // Return false if record empty or deleted
      if(token[0] == '#' || token[0] == '-')
        break;
      else if (term.substr(0, min((int)term.length(), TOKEN_SIZE)) == token) {
        Success = true;
        break;
      }
    }
  }
  else
    cerr << "Record " << RecordNum << " out of range.\n";

  // Reset to beginning of file
  Din.clear();
  Din.seekg(0);

  return Success;
}

/* Name:  Find
 * Parameters:  Din: reference to the Dict file
 *              Pin: reference to the Post file
 *              Min: reference to the Map file
 *              term: string of the queried term
 *              accumulator: array storing the sum weight of query term in
 *                           matching files
 * Purpose:  searches dict file for queried term, if found search post file,
 *           accumulator will then be updated
 * Returns:  true or false
*/
bool Find(ifstream &Din, ifstream &Pin, ifstream &Min,
           string term, int* accumulator,int* numRequired,int* numExcluded) {
  bool Success = false;
  unsigned long size = NUM_KEYS * 3;
  unsigned long Sum = 0, dictRecNum = 0;
  int numDocs = 0, start = 0;
  
  // Hashfunction to get the record number of the dict from the queried term 
  //cout<<term<<endl;
  for (long unsigned i=0; i < term.length(); i++){
    Sum = (Sum * 19) + term[i];  // Mult sum by 19, add byte value of 
  }
  dictRecNum = Sum % size;

  if(SearchDict(Din, dictRecNum, term, numDocs, start)){
    SearchPost(Pin, start, numDocs, accumulator,numRequired,numExcluded);
    Success = true;
  }
  //cout<<"Done"<<endl;

  return Success;
}

/* Name:  Query
 * Parameters:  tokenbuffer: String storing user query
 * Purpose:  Start query process
 * Returns:  nothing
*/

//here add a diferent array that contains the required terms and the excluded terms
void Query(char* tokenbuffer){
  ifstream Din, Pin, Min;
  Din.open(DICT_FILE.c_str());
  Pin.open(POST_FILE.c_str());
  Min.open(MAP_FILE.c_str());

  if(!Din)
    cerr << "Could not open " << DICT_FILE << ".\n";
  else if(!Pin)
    cerr << "Could not open " << POST_FILE << ".\n";
  else if(!Min)
    cerr << "Could not open " << MAP_FILE << ".\n";
  else {
    // Get record count of map file and set up accumulator array
    int num_records = 0;
    string line = "";

    while(getline(Min, line))
      num_records++;
    Min.clear();
    Min.seekg(0);

    int accumulator[num_records] = {0};
    int numRequired[num_records]= {0};
    int numExcluded[num_records]= {0};
    int map[num_records] = {0};

    for(int i = 0; i < num_records; i++)
      map[i] = i;

    // Split the string into separate terms and search
    char* token = strtok(tokenbuffer, " ");
    while(token) {
      if(!Find(Din, Pin, Min, token, accumulator,numRequired,numExcluded))
        cerr << "\"" << token << "\" could not be found in the collection.\n\n";
      token = strtok(NULL, " ");
    }

    PrintResults(Min, accumulator, map, num_records,numRequired,numExcluded);

    Din.close();
    Pin.close();
    Min.close();
  }
}

%}

/*-----------------------------------------------------------*/
/* Section of code which specifies lex substitution patterns */
/*-----------------------------------------------------------*/

DIGIT			[0-9]
LETTER			[A-Za-z]
UPPERCASE		[A-Z]
LOWERCASE		[a-z]
ALPHANUM		[A-Za-z0-9]

WORD			[A-Za-z][a-z]*
UPPERWORD		[A-Z0-9][A-Z0-9]*
HYPHENWORD		[A-Za-z]+(\-[A-Za-z]+)+
ABBREVIATION	[A-Za-z]+\.([A-Za-z]+\.)+

NUMBER 			[0-9]+(,[0-9]+)*
FLOAT 			[0-9]*\.[0-9]+
PHONENUMBER		[0-9]{3}-[0-9]{3}-[0-9]{4}
TIME			[0-9]{1,2}(:[0-9]{2})+
VERSION			[0-9]+\.[0-9]+(\.[0-9]+)+

URL				((http)|(ftp))s?:\/\/[A-Za-z0-9]+([\-\.]{1}[A-Za-z0-9]+)*\.[A-Za-z0-9]{2,}(:[0-9]{1,})?(\/[A-Za-z0-9_~\.\-]*)*
EMAIL 			[A-Za-z0-9_\-\.]+@([A-Za-z0-9_\-]+\.)+[A-Za-z0-9_\-]{2,4}

ATTRIBUTE 		[ \n\t]+(([A-Za-z\-_]+)?[ \n\t]*=?[ \n\t]*((\"[^\"]*\")|([A-Za-z0-9]+)|({URL}))[ \n\t]*)+[ \n\t]*
STARTTAG 		<!?[A-Za-z0-9]+{ATTRIBUTE}*[\/]?>
ENDTAG 			<[\/][A-Za-z0-9]+>

/*-----------------------------------------------------------*/
/* Section that spedifies regular expressions and actions    */
/*-----------------------------------------------------------*/

%%
{EMAIL}				Downcase(yytext); 
{URL}				Downcase(yytext);
{PHONENUMBER}			Downcase(yytext);
{FLOAT}				; 
{NUMBER}			; 
{TIME}				Downcase(yytext); 
{VERSION}			Downcase(yytext); 
{STARTTAG}			;
{ENDTAG}			;
{UPPERWORD}			Downcase(yytext); 
{ABBREVIATION}			Downcase(yytext); 
{HYPHENWORD}			Downcase(yytext); 
{WORD}				Downcase(yytext); 
[\n\t ]				;
.				;
%%

#undef yywrap
int yywrap() {
  return 1;
}

int main(int argc, char **argv) {
  string query = "", directory = "";
  int i = 0;

  if(argc < 4 || string(argv[argc-2]) != "-d") {
    cerr << "Incorrect number of arguments or did not specify directory.\n";
    return 0;
  }

  for(i = 1; i < (argc-2); i++){
    //cout<<argv[i]<<endl;
    queryTerms.push_back(argv[i]);
    requiredTerms.push_back(false);
    excludedTerms.push_back(false);
		query += argv[i];
		query += " ";
	}
  for(int i =0; i<queryTerms.size();i++){
    //if term type is 0 then it is a default term. if it is a 1 it is required and if it is a 2 is a excluded
    int termType=detectRequiredOrExcluded(queryTerms[i]);
    if(termType==1){
      cout<<queryTerms[i]<<" Required "<<"<br>"<<endl;
      numTermsRequired++;
      requiredTerms[i]=true;
    }
    if(termType==2){
      cout<<queryTerms[i]<<" Excluded "<<"<br>"<<endl;
      numTermsExcluded++;
      excludedTerms[i]=true;
    }
  }

  // Add directory path to files
  directory = argv[i+1];
  DICT_FILE.insert(0, directory);
  POST_FILE.insert(0, directory);
  MAP_FILE.insert(0, directory);

  char tokenbuffer[query.size()];
	QuickTokenize(tokenbuffer, query);
  Query(tokenbuffer);
}
