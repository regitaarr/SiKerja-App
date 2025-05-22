<?php 
date_default_timezone_set('Asia/Jakarta');

$hostname = 'localhost';
$username = 'root'; // Isi dengan username database
$password = ''; // Isi dengan password database 
$dbname   = 'kode';
$conn = mysqli_connect($hostname, $username, $password, $dbname);

// Cek koneksi
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}