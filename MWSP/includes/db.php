<?php
$host = "localhost";      // Server host
$user = "root";           // Username database
$password = "";           // Password database (kosong jika default di XAMPP)
$database = "db_crud";    // Nama database

// Membuat koneksi ke database
$conn = new mysqli($host, $user, $password, $database);

// Cek koneksi
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>