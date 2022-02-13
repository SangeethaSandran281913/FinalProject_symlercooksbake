<?php
    
    include_once("dbconnect.php");
    $email = $_POST['email'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    
    $sqlupdate = "UPDATE tbl_user SET user_name = '$name', user_phone ='$phone' WHERE user_email = '$email'";
    if ($conn->query($sqlupdate) === TRUE){
        echo 'Success';
        }else{
        echo 'Failed';
        }
?>