<?php

function crearUsuarioGuacamole($usuario, $password, $nombre = '', $email = '')
{
    try {
        $pdoGuac = new PDO(
            'mysql:host=localhost;dbname=guacamole_db;charset=utf8mb4',
            'root',
            'root', 
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]
        );

        
        $stmt = $pdoGuac->prepare("
            SELECT entity_id
            FROM guacamole_entity
            WHERE name = ? AND type = 'USER'
            LIMIT 1
        ");
        $stmt->execute([$usuario]);

        if ($stmt->fetch()) {
            throw new Exception("El usuario '$usuario' ya existe en Guacamole.");
        }

        
        $stmt = $pdoGuac->prepare("
            INSERT INTO guacamole_entity (name, type)
            VALUES (?, 'USER')
        ");
        $stmt->execute([$usuario]);

        $entityId = (int)$pdoGuac->lastInsertId();

        
        $salt = random_bytes(32);
        $hash = hash('sha256', $password . strtoupper(bin2hex($salt)), true);

        
        $stmt = $pdoGuac->prepare("
            INSERT INTO guacamole_user (
                entity_id,
                password_hash,
                password_salt,
                password_date,
                disabled,
                expired,
                full_name,
                email_address
            ) VALUES (
                ?, ?, ?, NOW(), 0, 0, ?, ?
            )
        ");

        $stmt->bindValue(1, $entityId, PDO::PARAM_INT);
        $stmt->bindValue(2, $hash, PDO::PARAM_LOB);
        $stmt->bindValue(3, $salt, PDO::PARAM_LOB);
        $stmt->bindValue(4, $nombre, PDO::PARAM_STR);
        $stmt->bindValue(5, $email, PDO::PARAM_STR);
        $stmt->execute();

        
        $stmt = $pdoGuac->prepare("
            SELECT ug.user_group_id
            FROM guacamole_user_group ug
            INNER JOIN guacamole_entity e ON e.entity_id = ug.entity_id
            WHERE e.name = 'USUARIOS'
            LIMIT 1
        ");
        $stmt->execute();
        $grupo = $stmt->fetch();

        if (!$grupo) {
            throw new Exception("No existe el grupo 'USUARIOS' en Guacamole.");
        }

        $userGroupId = (int)$grupo['user_group_id'];

        
        $stmt = $pdoGuac->prepare("
            INSERT INTO guacamole_user_group_member (user_group_id, member_entity_id)
            VALUES (?, ?)
        ");
        $stmt->execute([$userGroupId, $entityId]);

        return true;

    } catch (Exception $e) {
        throw new Exception("Error creando usuario en Guacamole: " . $e->getMessage());
    }
}
