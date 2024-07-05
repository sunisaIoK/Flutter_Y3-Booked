<?php

// Database configuration
$database_host = '127.0.0.1';
$database_name = 'profile';
$database_user = 'root';
$database_password = '';

// PDO database connection
try {
    $pdo = new PDO("mysql:host=$database_host;dbname=$database_name", $database_user, $database_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Echo for immediate confirmation
    echo "Successfully connected to the database.";

    // Log the successful connection
    error_log("Successfully connected to the database at " . date("Y-m-d H:i:s"));
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
