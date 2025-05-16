<?php
// File: db/includes/db.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Konfigurasi database
$host = "localhost";      // Server host
$user = "root";           // Username database
$password = "";           // Password database (kosong jika default di XAMPP)
$database = "db_crud";    // Nama database

// Membuat koneksi ke database
$conn = new mysqli($host, $user, $password, $database);

// Cek koneksi
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}
?>
