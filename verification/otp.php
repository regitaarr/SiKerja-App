<?php
header('Content-Type: application/json');
include 'api.php';

$response = [];

if (isset($_POST['submit-otp'])) {
    $nomor = mysqli_escape_string($conn, $_POST['nomor']);
    $nomor = preg_replace('/^0/', '62', $nomor); // Mengubah 0 menjadi 62 jika ada

    if ($nomor) {
        // Menghapus OTP sebelumnya jika ada
        if (!mysqli_query($conn, "DELETE FROM otp WHERE nomor = '$nomor'")) {
            $response['error'] = "Error description: " . mysqli_error($conn);
            echo json_encode($response);
            exit;
        }

        $curl = curl_init();
        $otp = rand(100000, 999999);
        $waktu = time();
        mysqli_query($conn, "INSERT INTO otp (nomor, otp, waktu) VALUES ('$nomor', '$otp', '$waktu')");
        
        $data = [
            'target' => $nomor,
            'message' => "Your OTP: " . $otp
        ];

        curl_setopt($curl, CURLOPT_HTTPHEADER, [
            "Authorization: xM8VT1bqn3719BuvfPqr",
        ]);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data));
        curl_setopt($curl, CURLOPT_URL, "https://api.fonnte.com/send");
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
        
        $result = curl_exec($curl);
        
        if ($result === false) {
            $response['error'] = 'Curl error: ' . curl_error($curl);
        } else {
            $response['success'] = 'OTP telah dikirim!';
        }

        curl_close($curl);

        file_put_contents('log.txt', "Nomor: $nomor, OTP: $otp, Waktu: $waktu, Result: $result\n", FILE_APPEND);
        echo json_encode($response);
        exit;
    }
}

elseif (isset($_POST['submit-login'])) {
    $otp = mysqli_escape_string($conn, $_POST['otp']);
    $nomor = mysqli_escape_string($conn, $_POST['nomor']);
    $q = mysqli_query($conn, "SELECT * FROM otp WHERE nomor = '$nomor' AND otp = '$otp'");
    $row = mysqli_num_rows($q);
    $r = mysqli_fetch_array($q);

    if ($row) {
        if (time() - $r['waktu'] <= 300) { // 300 detik atau 5 menit
            $response['status'] = 'success';
            $response['message'] = 'OTP benar';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'OTP expired';
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'OTP salah';
    }

    echo json_encode($response);
    exit;
}
?>
