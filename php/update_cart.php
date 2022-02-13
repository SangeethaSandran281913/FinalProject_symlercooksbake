<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];
$op = $_POST['op'];
$qty = $_POST['qty'];

if ($op == "addcart") {
    $sqlupdatecart = "UPDATE tbl_carts SET qty = qty +1 WHERE prid = '$prid' AND email = '$email'";
    if ($conn->query($sqlupdatecart) === TRUE) {
        echo "Success";
    } else {
        echo "Failed";
    }
}
if ($op == "removecart") {
    if ($qty == 1) {
        echo "Failed";
    } else {
        $sqlupdatecart = "UPDATE tbl_carts SET qty = qty - 1 WHERE prid = '$prid' AND email = '$email'";
        if ($conn->query($sqlupdatecart) === TRUE) {
            echo "Success";
        } else {
            echo "Failed";
        }
    }
}
?>