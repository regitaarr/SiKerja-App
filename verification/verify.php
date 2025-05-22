<?php
include 'api.php';

header('Content-Type: application/json'); // Set header untuk JSON response

if (isset($_POST['submit-login'])) {
    $nomor = mysqli_escape_string($conn, $_POST['nomor']);
    $otp = mysqli_escape_string($conn, $_POST['otp']);
    $currentTime = time();

    // Query untuk mencari OTP yang sesuai dengan nomor dan masih valid (misalnya, valid 5 menit)
    $query = "SELECT otp, waktu FROM otp WHERE nomor = '$nomor' ORDER BY waktu DESC LIMIT 1";
    $result = mysqli_query($conn, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $storedOtp = $row['otp'];
        $otpTime = $row['waktu'];
        
        // Verifikasi OTP dan cek waktu kadaluarsa (300 detik = 5 menit)
        if ($storedOtp == $otp && ($currentTime - $otpTime) <= 300) {
            // OTP valid
            echo json_encode(['status' => 'success', 'message' => 'OTP verified successfully']);
        } else {
            // OTP salah atau kadaluarsa
            echo json_encode(['status' => 'error', 'message' => 'Kode OTP salah atau kadaluarsa']);
        }
    } else {
        // Nomor tidak ditemukan
        echo json_encode(['status' => 'error', 'message' => 'OTP not found for this number']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
}
?>
