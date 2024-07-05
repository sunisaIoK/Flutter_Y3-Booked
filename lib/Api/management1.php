<?php
require_once 'config.php';
// Set the content type to JSON
header('Content-Type: application/json');
// Handle HTTP methods
$method = $_SERVER['REQUEST_METHOD'];
switch ($method) {
    case 'GET':
        // Read operation (fetch users)
        $stmt = $pdo->query('SELECT * FROM booked');
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result);
        break;
    case 'POST':
        // Create operation (add a new user)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];
        $typeTable = $data['typeTable'];
        $price = $data['price'];
        $bookedby = $data['bookedby'];
        $datetime = $data['datetime'];
        $status = $data['status'];
        

        $stmt = $pdo->prepare('INSERT INTO booked (id ,typeTable, price, bookedby, datetime, status) VALUES (?,?,?,?,?,?)');
        $stmt->execute([$id, $typeTable, $price, $bookedby, $datetime, $status]);

        echo json_encode(['message' => 'booked added successfully']);
        break;
    case 'PUT':
        // Update operation (edit a booked entry)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];
        $typeTable = $data['typeTable'];
        $price = $data['price'];
        $bookedby = $data['bookedby'];
        $datetime = $data['datetime'];
        $status = $data['status'];

        $stmt = $pdo->prepare('UPDATE booked SET typeTable=?, price=?, bookedby=?, datetime=?, status=? WHERE id=?');
        $success = $stmt->execute([$typeTable, $price, $bookedby, $datetime, $status, $id]);

        if ($success) {
            echo json_encode(['message' => 'booked updated successfully']);
        } else {
            echo json_encode(['message' => 'Failed to update booked']);
        }
        break;

    case 'DELETE':
        // Delete operation (remove a user)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];

        $stmt = $pdo->prepare('DELETE FROM booked WHERE id=?');
        $stmt->execute([$id]);

        echo json_encode(['message' => 'booked deleted successfully']);
        break;
    default:
        echo json_encode(['message' => 'Invalid request method']);
}
