<?php
require_once 'config.php';

// Set the content type to JSON
header('Content-Type: application/json');

// Handle HTTP methods
$method = $_SERVER['REQUEST_METHOD'];

if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');    // cache for 1 day
}

// Access-Control headers are received during OPTIONS requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    exit(0);
}

switch ($method) {
    case 'GET':
        // Read operation (fetch register)
        $stmt = $pdo->query('SELECT * FROM register');
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result);
        break;

    case 'POST':
        // Check if it's a login or registration request
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['login'])) {
            // Login operation
            $id = $data['id'];
            $password = $data['password'];

            // Fetch user from the database based on provided credentials
            $stmt = $pdo->prepare('SELECT * FROM register WHERE id = ? AND password = ?');
            $stmt->execute([$id, $password]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user) {
                echo json_encode(['message' => 'Login successful']);
            } else {
                echo json_encode(['message' => 'Login failed']);
            }
        } elseif (isset($data['profile'])) {
            // Registration operation
            $id = $data['id'];
            $password = $data['password'];
            $firstname = $data['firstname'];
            $lastname = $data['lastname'];
            $org = $data['org'];
            $id_auto = null;

            $stmt = $pdo->prepare('INSERT INTO register (id, password, firstname, lastname, org, id_auto) VALUES (?,?,?,?,?,?)');
            $stmt->execute([$id, $password, $firstname, $lastname, $org, $id_auto]);

            echo json_encode(['message' => 'User registered successfully']);
        } elseif (isset($data['fetchdata'])) {
            // fetchdata operation
            $id = $data['id'];

            // Fetch user from the database based on provided credentials
            $stmt = $pdo->prepare('SELECT * FROM register WHERE id = ?');
            $stmt->execute([$id]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user) {
                // Return user data in the JSON response
                echo json_encode([
                    'success' => true,
                    'id' => $user['id'],
                    'firstname' => $user['firstname'],
                    'lastname' => $user['lastname'],
                    'org' => $user['org']
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'User not found']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid request']);
        }
        break;


    case 'PUT':
        // Update operation (edit a user)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];
        $firstname = $data['firstname'];
        $lastname = $data['lastname'];
        $org = $data['org'];

        $stmt = $pdo->prepare('UPDATE register SET firstname=?, lastname=?, org=? WHERE id=?');
        $stmt->execute([$password, $firstname, $lastname, $org, $id]);

        echo json_encode(['message' => 'User updated successfully']);
        break;

    case 'DELETE':

        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];

        $stmt = $pdo->prepare('DELETE FROM register WHERE id=?');
        $stmt->execute([$id]);

        echo json_encode(['message' => 'User deleted successfully']);
        break;

    default:
        echo json_encode(['message' => 'Invalid request method']);
}
