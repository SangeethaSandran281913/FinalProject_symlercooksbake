<?php
    
    include_once("dbconnect.php");
    
    $email = $_POST['email'];
    $npassword = $_POST['npassword'];
    $passhal1 = sha1($npassword);
    $curpassword = $_POST['curpassword'];
    $passhal2 = sha1($curpassword);
    $status = $_POST['status'];
    $sqlcheck = "SELECT * FROM tbl_user WHERE user_email= '$email' AND user_password = '$passhal2'";
    $result = $conn-> query ($sqlcheck);
    if($status=="update" && $result ->num_rows>0){
     $sqlupdate = "UPDATE tbl_user SET user_password = '$passhal1' WHERE user_email= '$email'";
    if ($conn->query($sqlupdate) === TRUE){
        echo 'Update Success';
        }
        else{
        echo 'Update Failed';
        }
    }

?>