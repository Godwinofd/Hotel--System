<?php
$servername = "localhost";
$username_db = "root";
$password_db = ""; 
$database = "aaramhotel";

$conn = new mysqli($servername, $username_db, $password_db, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

session_start();

$username = $password = "";
$usernameErr = $passwordErr = "";
$loggedIn = false; 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (empty($_POST["username"])) {
        $usernameErr = "Username is required";
    } else {
        $username = test_input($_POST["username"]);
    }

    if (empty($_POST["password"])) {
        $passwordErr = "Password is required";
    } else {
        $password = test_input($_POST["password"]);
    }

    if (empty($usernameErr) && empty($passwordErr)) {
        $sql = "SELECT * FROM users WHERE username = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows == 1) {
            $row = $result->fetch_assoc();
            $hashed_password = $row['password_hash'];

            if (password_verify($password, $hashed_password)) {
                $loggedIn = true;

                $_SESSION['user_id'] = $row['user_id'];
            } else {
                $passwordErr = "Invalid username or password";
            }
        } else {
            $passwordErr = "Invalid username or password";
        }
    }
}

if(isset($_GET['cancel_booking'])) {
    $booking_id = $_GET['cancel_booking'];
    $sql = "DELETE FROM bookings WHERE booking_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $booking_id);
    if($stmt->execute()) {
        header("Location: ".$_SERVER['PHP_SELF']);
        exit();
    } else {
        echo "Error cancelling booking: " . $conn->error;
    }
}

if(isset($_POST['update_booking'])) {
    $booking_id = $_POST['booking_id'];
    $new_check_in_date = $_POST['new_check_in_date'];
    $new_check_out_date = $_POST['new_check_out_date'];

    $sql = "UPDATE bookings SET check_in_date = ?, check_out_date = ? WHERE booking_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssi", $new_check_in_date, $new_check_out_date, $booking_id);
    if($stmt->execute()) {
        header("Location: ".$_SERVER['PHP_SELF']);
        exit();
    } else {
        echo "Error updating booking: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $loggedIn ? 'My Reservations' : 'Sign In - Aaram Hotel'; ?></title>
    <link rel="stylesheet" href="signin_styles.css">
</head>
<body>
    <header>
        <div class="container">
            <h1>Aaram Hotel</h1>
            <nav>
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="explore.php">Explore</a></li>
                    <li><a href="aboutus.php">About Us</a></li>
                    <?php if ($loggedIn): ?>
                        <li><a href="index.html">Sign Out</a></li>
                    <?php else: ?>
                        <li><a href="signin.php">Sign In</a></li>
                    <?php endif; ?>
                </ul>
            </nav>
        </div>
    </header>

    <section class="main-content">
        <div class="container">
            <?php if ($loggedIn): ?>
                <h2>My Reservations</h2>
                <div class="reservation-list">
                    <?php
                    if (isset($_SESSION['user_id'])) {
                        $user_id = $_SESSION['user_id'];

                        $sql = "SELECT bookings.booking_id, bookings.check_in_date, bookings.check_out_date, rooms.room_type, rooms.price, hotels.address, hotels.city, hotels.country, users.first_name, users.last_name
                                FROM bookings
                                INNER JOIN rooms ON bookings.room_id = rooms.room_id
                                INNER JOIN hotels ON rooms.hotel_id = hotels.hotel_id
                                INNER JOIN users ON bookings.user_id = users.user_id
                                WHERE bookings.user_id = '$user_id'";
                        $result = $conn->query($sql);

                        if ($result->num_rows > 0) {
                            while ($row = $result->fetch_assoc()) {
                                echo "<div class='reservation'>";
                                echo "<h3>Booking ID: " . $row["booking_id"] . "</h3>";
                                echo "<p>Customer: " . $row["first_name"] . " " . $row["last_name"] . "</p>";
                                echo "<p>Room Type: " . $row["room_type"] . "</p>";
                                echo "<p>Check-in Date: " . $row["check_in_date"] . "</p>";
                                echo "<p>Check-out Date: " . $row["check_out_date"] . "</p>";
                                echo "<p>Price: £" . $row["price"] . "</p>";
                                echo "<p>Hotel Address: " . $row["address"] . ", " . $row["city"] . ", " . $row["country"] . "</p>";
                                echo "<form method='GET' action='".$_SERVER['PHP_SELF']."'>";
                                echo "<input type='hidden' name='cancel_booking' value='".$row["booking_id"]."'>";
                                echo "<input type='submit' value='Cancel Booking' class='btn cancel-btn'>";
                                echo "</form>";

                                echo "<form method='POST' action='".$_SERVER['PHP_SELF']."' class='update-form'>";
                                echo "<input type='hidden' name='booking_id' value='".$row["booking_id"]."'>";
                                echo "<label for='new_check_in_date'>New Check-in Date:</label>";
                                echo "<input type='date' id='new_check_in_date' name='new_check_in_date' required><br>";
                                echo "<label for='new_check_out_date'>New Check-out Date:</label>";
                                echo "<input type='date' id='new_check_out_date' name='new_check_out_date' required><br>";
                                echo "<input type='submit' value='Update Booking' name='update_booking' class='btn update-btn'>";
                                echo "</form>";

                                echo "</div>";
                            }
                        } else {
                            echo "<p>No reservations found.</p>";
                        }
                    }
                    ?>
                </div>
            <?php else: ?>
                <h2>Sign In</h2>
                <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
                    <label for="username">Username:</label><br>
                    <input type="text" id="username" name="username" value="<?php echo $username; ?>">
                    <span class="error"><?php echo $usernameErr; ?></span><br><br>
                    
                    <label for="password">Password:</label><br>
                    <input type="password" id="password" name="password">
                    <span class="error"><?php echo $passwordErr; ?></span><br><br>
                    
                    <input type="submit" value="Sign In">
                </form>
            <?php endif; ?>
        </div>
    </section>

    <footer>
        <div class="container">
            <p>&copy; 2024 Aaram Hotel. All rights reserved.</p>
            <p>Contact: contact@aaramhotel.com | Address: 123 Main Street, City, Country</p>
        </div>
    </footer>
</body>
</html>

<?php
function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}
?>
