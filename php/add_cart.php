<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];

$sqlcheckstock = "SELECT * FROM tbl_products WHERE prid = '$prid' ";

$resultstock = $conn->query($sqlcheckstock);
if ($resultstock->num_rows > 0) {
     while ($row = $resultstock ->fetch_assoc()){
            $sqlcheckcart = "SELECT * FROM tbl_carts WHERE prid = '$prid' AND email = '$email'"; 
            $resultcart = $conn->query($sqlcheckcart);
            if ($resultcart->num_rows == 0) {
                  $sqladdtocart = "INSERT INTO tbl_carts (email, prid, qty) VALUES ('$email','$prid','1')";
                if ($conn->query($sqladdtocart) === TRUE) {
                    echo "Success";
                } else {
                    echo "Failed";
                }
            } else { 
                 $sqlupdatecart = "UPDATE tbl_carts SET qty = qty +1 WHERE prid = '$prid' AND email = '$email'";
                if ($conn->query($sqlupdatecart) === TRUE) {
                    echo "Success";
                } else {
                    echo "Failed";
                }
            }
        
    }
}else{
    echo "Failed";
}

?>