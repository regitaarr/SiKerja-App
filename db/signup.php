<?php
// File: mwsp/signup.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Menyertakan file db.php
require 'includes/db.php';

// Mendapatkan data dari permintaan dalam format JSON
$data = json_decode(file_get_contents("php://input"));

// Memastikan bahwa username, email, dan password dikirim dalam permintaan
if (isset($data->username) && isset($data->email) && isset($data->password)) {
    $username = $data->username;
    $email = $data->email;
    $password = $data->password;

    // Memeriksa apakah username atau email sudah ada di database
    $checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
    $stmt = $conn->prepare($checkSql);
    $stmt->bind_param("ss", $username, $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Jika username atau email sudah ada, kembalikan respons error
        echo json_encode(["status" => "error", "message" => "Username or email already exists"]);
    } else {
        // Jika tidak, lanjutkan untuk memasukkan pengguna baru ke database
        $insertSql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertSql);
        $stmt->bind_param("sss", $username, $email, $password);

        if ($stmt->execute()) {
            // Jika pemasukan berhasil, kembalikan respons sukses
            echo json_encode(["status" => "success", "message" => "User registered successfully"]);
        } else {
            // Jika ada kesalahan saat memasukkan pengguna, kembalikan respons error
            echo json_encode(["status" => "error", "message" => "Failed to register user"]);
        }
    }
    // Menutup statement
    $stmt->close();
} else {
    // Jika username, email, atau password tidak dikirim, kembalikan respons error
    echo json_encode(["status" => "error", "message" => "Username, email, and password are required"]);
}

// Menutup koneksi ke database
$conn->close();
?>
