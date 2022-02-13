<?php
$servername = "localhost";
$username = "id18326651_sangeetha21";
$password = "+Dh^Y+!N{s3X7n18";
$database = "id18326651_symlercooksbake";

$conn = new mysqli($servername, $username, $password, $database);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>