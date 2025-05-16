<?php
header("Content-Type: application/json");

// Include the database configuration file
require 'includes/db.php'; 

// Get the data from the request in JSON format
$data = json_decode(file_get_contents("php://input"));

// Ensure that username, email, and password are sent in the request
if (isset($data->username) && isset($data->email) && isset($data->password)) {
    $username = $data->username; // Get the username value from the data
    $email = $data->email;       // Get the email value from the data
    $password = $data->password; // Get the password value from the data

    // Check if the username or email already exists in the database
    $checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
    $stmt = $conn->prepare($checkSql);
    $stmt->bind_param("ss", $username, $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // If username or email exists, return error response
        echo json_encode(["status" => "error", "message" => "Username or email already exists"]);
    } else {
        // If not, proceed to insert the new user into the database
        $insertSql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertSql);
        
        // Do not hash the password, store it in plaintext
        $stmt->bind_param("sss", $username, $email, $password);

        if ($stmt->execute()) {
            // If insertion is successful, return success response
            echo json_encode(["status" => "success", "message" => "User registered successfully"]);
        } else {
            // If there was an error inserting the user, return error response
            echo json_encode(["status" => "error", "message" => "Failed to register user"]);
        }
    }
    // Close the statement
    $stmt->close();
} else {
    // If username, email, or password is not sent, return error response
    echo json_encode(["status" => "error", "message" => "Username, email, and password are required"]);
}

// Close the database connection
$conn->close();
?>