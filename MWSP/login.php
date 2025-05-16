<?php
header("Content-Type: application/json");

// Include the database configuration file
require 'includes/db.php';

// Get the data from the request in JSON format
$data = json_decode(file_get_contents("php://input"));

// Ensure data username and password are sent in the request
if (isset($data->username) && isset($data->password)) {
    $username = $data->username;
    $password = $data->password;

    // Query to check if user exists with provided credentials
    $sql = "SELECT id, username, email FROM users WHERE username = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if any user matches the credentials
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        // Return user data along with success status
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
        // If no matching user found
        echo json_encode(["status" => "error", "message" => "Invalid username or password"]);
    }

    $stmt->close();
} else {
    // If username or password not sent in the request
    echo json_encode(["status" => "error", "message" => "Username and password required"]);
}

// Close the database connection
$conn->close();
?>
