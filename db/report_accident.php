<?php
// File: db/report_accident.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Menyertakan file db.php
require 'includes/db.php';

// Mendapatkan data dari permintaan dalam format JSON
$data = json_decode(file_get_contents("php://input"));

$response = [];

// Memastikan bahwa semua field dikirim dalam permintaan
if (
    isset($data->nik) && isset($data->nama) &&
    isset($data->date) && isset($data->time) &&
    isset($data->location) && isset($data->description)
) {
    $nik = mysqli_real_escape_string($conn, $data->nik);
    $nama = mysqli_real_escape_string($conn, $data->nama);
    $date = mysqli_real_escape_string($conn, $data->date);
    $time = mysqli_real_escape_string($conn, $data->time);
    $location = mysqli_real_escape_string($conn, $data->location);
    $description = mysqli_real_escape_string($conn, $data->description);

    // Insert laporan kecelakaan ke database
    $insert_query = "INSERT INTO accident_reports (nik, nama, date, time, location, description, status) VALUES (?, ?, ?, ?, ?, ?, 'Ditunda')";
    $stmt = $conn->prepare($insert_query);
    $stmt->bind_param("ssssss", $nik, $nama, $date, $time, $location, $description);

    if ($stmt->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Laporan kecelakaan berhasil dikirim';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Gagal mengirim laporan kecelakaan: ' . mysqli_error($conn);
    }

    $stmt->close();
} else {
    $response['status'] = 'error';
    $response['message'] = 'Semua field harus diisi';
}

$conn->close();

echo json_encode($response);
?>
