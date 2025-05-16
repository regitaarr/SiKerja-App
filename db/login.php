<?php
// File: db/login.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Menyertakan file db.php
require 'includes/db.php';

// Mendapatkan data dari permintaan dalam format JSON
$data = json_decode(file_get_contents("php://input"));

// Memastikan bahwa username dan password dikirim dalam permintaan
if (isset($data->username) && isset($data->password)) {
    $username = $data->username;
    $password = $data->password;

    // Query untuk memeriksa apakah pengguna ada dengan kredensial yang diberikan
    $sql = "SELECT id, username, email FROM users WHERE username = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    // Memeriksa apakah ada pengguna yang cocok
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        // Mengembalikan data pengguna beserta status sukses
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => [
                "id" => $user['id'],
                "username" => $user['username'],
                "email" => $user['email']
            ]
        ]);
    } else {
        // Jika tidak ada pengguna yang cocok
        echo json_encode(["status" => "error", "message" => "Invalid username or password"]);
    }

    $stmt->close();
} else {
    // Jika username atau password tidak dikirim dalam permintaan
    echo json_encode(["status" => "error", "message" => "Username and password required"]);
}

// Menutup koneksi ke database
$conn->close();
?>
