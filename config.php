<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'mariadb';
$CFG->dbname    = 'bitnami_moodle';
$CFG->dbuser    = 'bn_moodle';
$CFG->dbpass    = 'moodle_password';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_general_ci',
);

if (empty($_SERVER['HTTP_HOST'])) {
  $_SERVER['HTTP_HOST'] = '127.0.0.1:8080';
}
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
  $CFG->wwwroot   = 'https://' . $_SERVER['HTTP_HOST'];
} else {
  $CFG->wwwroot   = 'http://' . $_SERVER['HTTP_HOST'];
}
$CFG->dataroot  = '/bitnami/moodledata';
$CFG->admin     = 'admin';
//Aqui inicia bloque modificado

//configura nuestras rutas de ingreso alternas $CFG->alternateloginurl, las separamos por una coma y la primera se tomara como base
//$CFG->alternateloginurl = 'http://127.0.0.1:8081/loginSample.html, http://127.0.0.1:8081/loginSample1.html, http://127.0.0.1:8081/loginSample2.html';  


//configura nuestras rutas de ingreso alternas $CFG->alternateloginurl, las separamos por una coma y la primera se tomara como base
//Si las definimos dentro de moodle las podemos usar como rutas relativas

$CFG->alternateloginurl = '/general/, /amafore/, /examen/';  


//Nuestros roles que se usaran para redirigir a su correspondiente ruta  ejemplo '/cursos/' se traduce como http://localhost:8080/cursos/
$CFG->alternatelogouturl = array(
  'student_exam' => '/amafore/',
  'student_amafore' => '/examen/'
);

//Nuestra ruta default para cualquier rol no definido en nuestros roles de redireccion
$CFG->alternateLogoutUrlDefaultRol = '/general/';

//Aqui termina bloque modificado

$CFG->directorypermissions = 02775;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!