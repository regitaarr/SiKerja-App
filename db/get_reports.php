<?php
// File: db/get_reports.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

require 'includes/db.php';

$response = [];

// Mendapatkan data laporan dari tabel accident_reports
$query = "SELECT nik, nama, date, time, location, description, status FROM accident_reports ORDER BY date DESC, time DESC";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    $reports = [];
    while ($row = $result->fetch_assoc()) {
        $reports[] = $row;
    }
    $response['status'] = 'success';
    $response['reports'] = $reports;
} else {
    $response['status'] = 'error';
    $response['message'] = 'Tidak ada laporan ditemukan';
}

$conn->close();

echo json_encode($response);
?>
