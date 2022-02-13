<?php
include_once("dbconnect.php");
$email = $_POST['email'];

if($email=="admin"){
$sqlloadhistory = "SELECT * FROM tbl_history 
INNER JOIN tbl_products ON tbl_history.prid= tbl_products.prid
INNER JOIN tbl_purchased ON tbl_history.orderid = tbl_purchased.orderid
ORDER BY tbl_purchased.date_purchase DESC
";
$result = $conn->query($sqlloadhistory);


if ($result->num_rows > 0 ) {
    $response['history'] = array();
    while ($row = $result->fetch_assoc()) {
        $historylist['prid'] = $row['prid'];
        $historylist['prname'] = $row['prname'];
        $historylist['prprice'] = $row['prprice'];
        $historylist['qty'] = $row['qty'];
        $historylist['orderid'] = $row['orderid'];
        $historylist['paid'] = $row['paid'];
        $historylist['status'] = $row['status'];
        $historylist['date_purchase'] = $row['date_purchase'];
        array_push($response['history'], $historylist);
    }
    echo json_encode($response);
} 
else {
    echo "nodata";
}
}
else{
$sqlloadhistory = "SELECT * FROM tbl_history 
INNER JOIN tbl_products ON tbl_history.prid= tbl_products.prid
INNER JOIN tbl_purchased ON tbl_history.orderid = tbl_purchased.orderid
WHERE tbl_history.email = '$email'
ORDER BY tbl_purchased.date_purchase DESC
";
$result = $conn->query($sqlloadhistory);


if ($result->num_rows > 0 ) {
    $response['history'] = array();
    while ($row = $result->fetch_assoc()) {
        $historylist['prid'] = $row['prid'];
        $historylist['prname'] = $row['prname'];
        $historylist['prprice'] = $row['prprice'];
        $historylist['qty'] = $row['qty'];
        $historylist['orderid'] = $row['orderid'];
        $historylist['paid'] = $row['paid'];
        $historylist['status'] = $row['status'];
        $historylist['date_purchase'] = $row['date_purchase'];
        array_push($response['history'], $historylist);
    }
    echo json_encode($response);
} 
else {
    echo "nodata";
}
}
?>