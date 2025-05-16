<?php
// File: mwsp/forgot_password.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Menyertakan file db.php
require 'includes/db.php';

// Mendapatkan data dari permintaan dalam format JSON
$data = json_decode(file_get_contents("php://input"));

// Memastikan bahwa identifier dan new_password dikirim dalam permintaan
if (isset($data->identifier) && isset($data->new_password)) {
    $identifier = trim($data->identifier);
    $new_password = trim($data->new_password);

    // Validasi apakah identifier adalah email atau username
    if (filter_var($identifier, FILTER_VALIDATE_EMAIL)) {
        // Identifier adalah email
        $query = "SELECT * FROM users WHERE email = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $identifier);
    } else {
        // Identifier adalah username
        $query = "SELECT * FROM users WHERE username = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $identifier);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Pengguna ditemukan, lakukan update password
        $user = $result->fetch_assoc();
        $user_id = $user['id'];

        $update_query = "UPDATE users SET password = ? WHERE id = ?";
        $update_stmt = $conn->prepare($update_query);
        $update_stmt->bind_param("si", $new_password, $user_id);

        if ($update_stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Password berhasil diperbarui"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal memperbarui password"]);
        }
        $update_stmt->close();
    } else {
        // Pengguna tidak ditemukan
        echo json_encode(["status" => "error", "message" => "Pengguna tidak ditemukan"]);
    }
    $stmt->close();
} else {
    // Field yang diperlukan tidak lengkap
    echo json_encode(["status" => "error", "message" => "Identifier dan new password diperlukan"]);
}

// Menutup koneksi ke database
$conn->close();
?>
