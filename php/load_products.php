<?php
if (!isset($_POST)){
    echo "failed";
}

include_once("dbconnect.php");
$prname= $_POST['prname'];

if ($prname == "all") {
    $sqlload = "SELECT * FROM tbl_products ORDER BY prid DESC";
} 
else if($prname == "null"){
    echo("null");
}
else {
    $sqlload = "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%' ORDER BY prid DESC";
} 
$result = $conn->query($sqlload);

if ($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $prlist = array();
        $prlist['prid'] = $row['prid'];
        $prlist['prname'] = $row['prname'];
        $prlist['prdesc'] = $row['prdesc'];
        $prlist['pringredient'] = $row['pringredient'];
        $prlist['prallergen'] = $row['prallergen'];
        $prlist['prweight'] = $row['prweight'];
        $prlist['prprice'] = $row['prprice'];
        array_push($response["products"],$prlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>