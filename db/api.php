<?php
// File: db/api.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Menyertakan file db.php
require 'includes/db.php';

// Mendapatkan metode permintaan
$request_method = $_SERVER["REQUEST_METHOD"];

switch($request_method) {
    case 'GET':
        if (isset($_GET['id'])) {
            get_user($conn, $_GET['id']);
        } else {
            get_users($conn);
        }
        break;
    case 'POST':
        create_user($conn);
        break;
    case 'PUT':
        update_user($conn, $_GET['id']);
        break;
    case 'DELETE':
        parse_str(file_get_contents("php://input"), $_DELETE);
        if (isset($_GET['username'])) {
            delete_user($conn, $_GET['username']);
        } else {
            echo json_encode(["status" => "error", "message" => "Username required"]);
        }
        break;
    default:
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        break;
}

$conn->close();

// Fungsi untuk mendapatkan semua pengguna
function get_users($conn) {
    $sql = "SELECT * FROM users";
    $result = $conn->query($sql);
    $users = [];
    while ($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
    echo json_encode($users);
}

// Fungsi untuk mendapatkan pengguna berdasarkan ID
function get_user($conn, $id) {
    $sql = "SELECT * FROM users WHERE id = $id";
    $result = $conn->query($sql);
    $user = $result->fetch_assoc();
    if ($user) {
        echo json_encode($user);
    } else {
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }
}

// Fungsi untuk membuat pengguna baru
function create_user($conn) {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    if ($username && $password) {
        $sql = "INSERT INTO users (username, password) VALUES ('$username', '$password')";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User created successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Username and password required"]);
    }
}

// Fungsi untuk memperbarui pengguna
function update_user($conn, $id) {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    if ($username && $password) {
        $sql = "UPDATE users SET username='$username', password='$password' WHERE id=$id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User updated successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Username and password required"]);
    }
}

// Fungsi untuk menghapus pengguna
function delete_user($conn, $username) {
    $sql = "DELETE FROM users WHERE username='$username'";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "User deleted successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
    }
}
?>

// Fungsi untuk memperbarui pengguna
function update_report($conn, $id) {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    if ($username && $password) {
        $sql = "UPDATE users SET username='$username', password='$password' WHERE id=$id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User updated successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Username and password required"]);
    }
}