<html>
<head><title>Know's more Results</title></head>
<body style="background-color:#5C946E">
<center>
<img src='//images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/16c16e11-5180-4234-bb37-66c7486330b9/dctuize-a1f9ce3a-281b-4b7c-905c-a412fb7f432a.png/v1/fill/w_1280,h_379,strp/knowsmore_logo___reconstructed_by_knowsmore_dctuize-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9Mzc5IiwicGF0aCI6IlwvZlwvMTZjMTZlMTEtNTE4MC00MjM0LWJiMzctNjZjNzQ4NjMzMGI5XC9kY3R1aXplLWExZjljZTNhLTI4MWItNGI3Yy05MDVjLWE0MTJmYjdmNDMyYS5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.JXkjwHaY5w_iV6HjfMlbfcczsZnChuQNKmmCc9pBE5o' width="800" height="200" /> 
</center>
    <center>
       <font face="Arial" font-size="30px" color="#474747">This are the results of your query</font>
    </center>
    <center>
        <font face="Arial" font-size="15px" color="#8f3985">
        <?php
        //Commented out since I only had to call it once
        // for ($x = 1; $x <= 1954; $x+=1) {
        //     $File = fopen('/home/eaduran/public_html/Titles/' . $x . '.txt', 'w') or die("Unable to open file!");
        //     echo shell_exec('chmod a=rw /home/eaduran/public_html/Titles/' . $x . '.txt');
        //     $txt = GetTitle('http://csce.uark.edu/~eaduran/files/' . $x . '.html');
        //     fwrite($File, $txt);
        //     fclose($File);
        // }
        $requiredTerms="";
        $excludedTerms="";
        if($_POST[required_term]!="") {
            $requiredTerms.=" ";
            $requiredTerms.=  $_POST[required_term];
            
        }if($_POST[excluded_term]!="") {
            $excludedTerms.=" ";
            $excludedTerms.=  $_POST[excluded_term];
        }
        if(isset($_POST[required_term])||isset($_POST[default_term])) {
            // echo './hw4.sh '. $_POST[default_term] . ' '. str_replace(" "," +",$requiredTerms) .' '. str_replace(" "," -",$excludedTerms) . ' -d /home/eaduran/public_html/out';
            echo shell_exec('./hw4.sh '. $_POST[default_term] . " ". str_replace(" "," +",$requiredTerms) .' '. str_replace(" "," -",$excludedTerms) . ' -d /home/eaduran/public_html/out');
        }
        function GetTitle($url) {
            $data = file_get_contents($url);
            $title = preg_match('/<title[^>]*>(.*?)<\/title>/ims', $data, $matches) ? $matches[1] : null;
            return $title;
        }
        
            
        
        //generateTitlesFile();
        ?>
        </font>
    </center>
</body>
</html>