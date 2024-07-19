<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .login-container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .login-container h1 {
        margin-bottom: 20px;
    }

    .login-container input {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    .login-container button {
        width: 100%;
        padding: 10px;
        background-color: #25552b;
        border: none;
        color: #fff;
        border-radius: 4px;
        cursor: pointer;
    }

    .login-container button:hover {
        background-color: #0056b3;
    }
    </style>
</head>

<body>
    <div class="login-container">
        <h1>Iniciar Sesión</h1>
        <!--Matener Form -->
        <form class="login-form" action="/login/index.php" method="post" id="login">
            <input type="hidden" name="logintoken" value="qK6IQ2aRptoEZu0bBQWUVhLyf1Aoy6oE">
            <div class="login-form-username form-group">
                <label for="username" class="sr-only">
                    Usuario
                </label>
                <input type="text" name="username" id="username" class="form-control form-control-lg" value="user"
                    placeholder="Usuario" autocomplete="username">
            </div>
            <div class="login-form-password form-group">
                <label for="password" class="sr-only">Contraseña</label>
                <input type="password" name="password" id="password" value="" class="form-control form-control-lg"
                    placeholder="Contraseña" autocomplete="current-password">
            </div>
            <div class="login-form-submit form-group">
                <button class="loginbtn btn btn-primary btn-lg btn-block" type="submit" id="loginbtn">Iniciar sesión
                    (ingresar)</button>
            </div>
            <div class="login-form-forgotpassword form-group">
                <a href="http://localhost:8080/login/forgot_password.php">¿Ha extraviado la contraseña?</a>
            </div>
        </form>
    </div>
</body>

</html>