<?php

// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Logs the user out and sends them to the home page
 *
 * @package    core
 * @subpackage auth
 * @copyright  1999 onwards Martin Dougiamas  http://dougiamas.com
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

 /* 
require_once('../config.php');

$PAGE->set_url('/login/logout.php');
$PAGE->set_context(context_system::instance());

$sesskey = optional_param('sesskey', '__notpresent__', PARAM_RAW); // we want not null default to prevent required sesskey warning
$login   = optional_param('loginpage', 0, PARAM_BOOL);

// can be overridden by auth plugins
if ($login) {
    $redirect = get_login_url();
} else {
    $redirect = $CFG->wwwroot.'/';
}

if (!isloggedin()) {
    // no confirmation, user has already logged out
    require_logout();
    redirect($redirect);

} else if (!confirm_sesskey($sesskey)) {
    $PAGE->set_title(get_string('logout'));
    $PAGE->set_heading($SITE->fullname);
    echo $OUTPUT->header();
    echo $OUTPUT->confirm(get_string('logoutconfirm'), new moodle_url($PAGE->url, array('sesskey'=>sesskey())), $CFG->wwwroot.'/');
    echo $OUTPUT->footer();
    die;
}

$authsequence = get_enabled_auth_plugins(); // auths, in sequence
foreach($authsequence as $authname) {
    $authplugin = get_auth_plugin($authname);
    $authplugin->logoutpage_hook();
}

require_logout();

redirect($redirect);
*/

require_once(__DIR__ . '/../config.php');
require_once($CFG->libdir . '/authlib.php');
require_once($CFG->libdir . '/datalib.php');
require_once($CFG->dirroot . '/user/lib.php');

// Obtener el id del usuario
$userid = $USER->id;
// Obtener todos los cursos en los que el usuario está inscrito.
$user_courses = enrol_get_users_courses($userid);

// Define las URLs de redirección según el rol
$redirect_urls = array(
    'student' => 'http://127.0.0.1:5500/loginSample1.html',
    'teacher' => 'http://127.0.0.1:5500/loginSample2.html',
);
// Recorrer cada curso y obtener los roles del usuario en ese curso.
foreach ($user_courses as $course) {
    //verifica el rol del usuario por el id del curso
    $context = context_course::instance($course->id);
    $roles = get_user_roles($context, $userid);
    // Si se encontraron roles,se recorren para buscar una coincidencia con nuestra lista de redireccion
    if (!empty($roles)) {
        // Redirige según el rol del usuario
            foreach ($roles as $role) {
                if (isset($redirect_urls[$role->shortname])) {
                    $redirect_url = $redirect_urls[$role->shortname];
                    break;
                }
            }
    }
}








// Si no se encuentra un rol específico, redirige a una página por defecto
if (!isset($redirect_url)) {
    $redirect_url='http://127.0.0.1:5500/loginSample.html';
}

//destruir la sesion
require_logout();
// Redirige al usuario
redirect($redirect_url);