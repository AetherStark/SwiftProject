<?php
/*
 * El siguiente código localiza los reportes
 * Stark Abril/2020
 */
$response = array();
$Cn = mysqli_connect("localhost", "root", "", "securityapp") or die("server no encontrado");
mysqli_set_charset($Cn, "utf8");
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $obj= json_decode(file_get_contents("php://input"),true);

    $correo = $obj['corrUsr']; 

    $result = mysqli_query($Cn, "SELECT idreporte,ubicacion,latitud,longitud,fecha,descripcion,Titulo,puntuacion FROM reportes WHERE corrUsr = '$correo' ORDER BY idreporte");
    if (!empty($result)) {
        if (mysqli_num_rows($result) > 0) {
            while ($res = mysqli_fetch_array($result)) {
                $reporte = array();
                $reporte["success"] = 200;
                $reporte["message"] = "reporte encontrado";
                $reporte["idreporte"] = $res["idreporte"];
                $reporte["ubicacion"] = $res["ubicacion"];
                $reporte["latitud"] = $res["latitud"];
                $reporte["longitud"] = $res["longitud"];
                $reporte["fecha"] = $res["fecha"];
                $reporte["descripcion"] = $res["descripcion"];
                $reporte["Titulo"] = $res["Titulo"];
                $reporte["puntuacion"] = $res["puntuacion"];
                array_push($response, $reporte);
            }
            echo json_encode($response);
        } else {
            $reporte = array();
            $reporte["success"] = 404; //No encontro información y el success = 0 indica no exitoso
            $reporte["message"] = "reporte no encontrado";
            array_push($response, $reporte);
            echo json_encode($response);
        }
    } else {
        $reporte = array();
        $reporte["success"] = 404; //No encontro información y el success = 0 indica no exitoso
        $reporte["message"] = "reporte no encontrado";
        array_push($response, $reporte);
        echo json_encode($response);
    }
} else {
    $reporte = array();
    $reporte["success"] = 400;
    $reporte["message"] = "Faltan Datos entrada";
    array_push($response, $reporte);
    echo json_encode($response);
}
mysqli_close($Cn);
