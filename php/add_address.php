<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$name= $_POST['name'];
$address = $_POST['address'];
$phone = $_POST['phone'];

$sqlcheckaddress = "SELECT * FROM tbl_address WHERE email = '$email' AND name = '$name' AND address = '$address' AND phone = '$phone'"; 
$resultcheck = $conn->query($sqlcheckaddress);
    if ($resultcheck->num_rows != 0) {
          echo "Already Exist";
        }
else{
$sqladdaddress = "INSERT INTO tbl_address (email, name, address, phone) VALUES ('$email','$name', '$address', '$phone')";
            if ($conn->query($sqladdaddress) === TRUE) {
                echo "Success";
            } else {
                echo "Failed";
            }
    
}
?>