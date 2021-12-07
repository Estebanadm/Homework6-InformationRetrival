<html>
<head><title>Know's more Results</title></head>
<body style="background-color:#5C946E">
<center>
<img src='//images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/16c16e11-5180-4234-bb37-66c7486330b9/dctuize-a1f9ce3a-281b-4b7c-905c-a412fb7f432a.png/v1/fill/w_1280,h_379,strp/knowsmore_logo___reconstructed_by_knowsmore_dctuize-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9Mzc5IiwicGF0aCI6IlwvZlwvMTZjMTZlMTEtNTE4MC00MjM0LWJiMzctNjZjNzQ4NjMzMGI5XC9kY3R1aXplLWExZjljZTNhLTI4MWItNGI3Yy05MDVjLWE0MTJmYjdmNDMyYS5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.JXkjwHaY5w_iV6HjfMlbfcczsZnChuQNKmmCc9pBE5o' width="800" height="200" /> 
</center>
    <center>
       <font face="Arial" size="20px" color="#474747">This are the results of your query</font>
    </center>
    <center>
        <font face="Arial" size="15px" color="#8f3985">
        <?php
        if(isset($_POST[input_query])) {
            $name = htmlspecialchars($_POST[input_query]);
            echo shell_exec('./hw4.sh ' . $_POST[input_query] . ' -d /home/eaduran/public_html/out');
        }
        ?>
        </font>
    </center>
</body>
</html>