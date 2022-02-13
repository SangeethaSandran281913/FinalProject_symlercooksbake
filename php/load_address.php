<?php

include_once("dbconnect.php");
$email = $_POST['email'];

$sqlloadaddress = "SELECT * FROM tbl_address WHERE email = '$email'";
$result = $conn->query($sqlloadaddress);

if ($result->num_rows > 0){
    $response["address"] = array();
    while ($row = $result -> fetch_assoc()){
        $addresslist = array();
        $addresslist['email'] = $row['email'];
        $addresslist['name'] = $row['name'];
        $addresslist['address'] = $row['address'];
        $addresslist['phone'] = $row['phone'];
        array_push($response["address"],$addresslist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>