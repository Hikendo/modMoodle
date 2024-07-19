El archivo config va en la raiz se modifica la linea 32
El archivo index va en el directorio login se modifica a partir de la linea 329
El archivo logout va en el directorio login se modifica todo el archivo, para ignorar otros plugins de redireccionamiento

Los archivos sample.html van en una ubicacion diferente y sirven como caratulas de login
# Modificaciones moodle

Descripción breve del proyecto.

## Tabla de Contenidos


- [Config.php](#config)

## Config

Configura nuestras rutas de ingreso alternas $CFG->alternateloginurl, las separamos por una coma y la primera se tomara como base
Si las definimos dentro de moodle las podemos usar como rutas relativas

$CFG->alternateloginurl = '/general/, /cursos/, /examen/';  


//Nuestros roles que se usaran para redirigir a su correspondiente ruta  ejemplo '/cursos/' se traduce como http://localhost:8080/cursos/
$CFG->alternatelogouturl = array(
  'student' => '/cursos/',
  'teacher' => '/examen/'
);

//Nuestra ruta default para cualquier rol no definido en nuestros roles de redireccion
$CFG->alternateLogoutUrlDefaultRol = '/general/';
