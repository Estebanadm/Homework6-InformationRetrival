#include <fstream>
#include <iostream>
using namespace std;

int main(int argc, char* argv[])
{
string InFilename, OutFilename;
ifstream din;
ofstream dout;

   if (argc != 3)
      cerr << "Not the right number of arguments.\n";
if (!din)
         cerr << "Could not open input file: ”
                << InFilename << endl;
 else
      {
         OutFilename = argv[2];  
         cout << "The output filename is: " << OutFilename << endl;
         dout.open(OutFilename.c_str());
         if (!dout)
            cerr << "Could not open output file: " 
                    << OutFilename <<   endl;
else
       {
            string Token;
            cout << "Opened " << InFilename << " for reading.\n";
            cout << "Opened " << OutFilename << " for writing.\n";
            while (din >> Token)
                   dout << ":" << Token << ":\n";
            din.close();
            dout.close();
         }
      }
   }
   return 0;
}
