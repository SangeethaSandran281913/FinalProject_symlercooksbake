<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlloadcart = "SELECT * FROM tbl_carts INNER JOIN tbl_products ON tbl_carts.prid = tbl_products.prid WHERE tbl_carts.email = '$email'";;

$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0) {
    $response['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $prlist['prid'] = $row['prid'];
        $prlist['prname'] = $row['prname'];
        $prlist['prprice'] = $row['prprice'];
        $prlist['cartqty'] = $row['qty'];
        array_push($response['cart'], $prlist);
    }
    echo json_encode($response);
} else {
    echo "nodata";
}

?>